import XCTest
@testable import ForgeUI

/// Mirrors Flutter `fui_text_field_test.dart` + `fui_pickers`/OTP coverage. The
/// text well, error state, OTP cell count, and page control all expose observable
/// hierarchy after `configure`.
@MainActor
final class FUITextFieldTests: XCTestCase {

    // MARK: - FUITextField

    func testTextFieldShowsLabelAndText() {
        let field = FUITextField()
        field.configure(with: .init(label: "Email", placeholder: "you@x.com", text: "a@b.com"))
        XCTAssertNotNil(field.fui_visibleLabel(text: "Email"))
        let textField = field.fui_firstSubview(ofType: UITextField.self)
        XCTAssertEqual(textField?.text, "a@b.com")
    }

    func testTextFieldHidesLabelWhenNil() {
        let field = FUITextField()
        field.configure(with: .init(label: nil, placeholder: "Search"))
        // The label sub-view exists but is hidden; placeholder lives on the UITextField.
        let labels = field.fui_subviews(ofType: UILabel.self)
        XCTAssertTrue(labels.allSatisfy { $0.isHidden || ($0.text ?? "").isEmpty })
    }

    func testTextFieldIconDoesNotOverlapText() {
        let field = FUITextField()
        field.configure(with: .init(placeholder: "you@x.com", iconName: FUIIcons.person))
        field.frame = CGRect(x: 0, y: 0, width: 320, height: 80)
        field.layoutIfNeeded()
        let icon = field.fui_subviews(ofType: UIImageView.self).first { !$0.isHidden }
        let tf = field.fui_firstSubview(ofType: UITextField.self)
        XCTAssertNotNil(icon); XCTAssertNotNil(tf)
        // The text field must begin at or after the icon's trailing edge (icon + text share the well).
        XCTAssertGreaterThanOrEqual(tf!.frame.minX, icon!.frame.maxX - 0.5,
            "leading icon overlaps the text field")
    }

    func testTextFieldSecureEntry() {
        let field = FUITextField()
        field.configure(with: .init(placeholder: "Password", isSecure: true))
        let textField = field.fui_firstSubview(ofType: UITextField.self)
        XCTAssertEqual(textField?.isSecureTextEntry, true)
    }

    func testTextFieldErrorStateShowsMessageAndRedBorder() {
        let field = FUITextField()
        field.configure(with: .init(label: "Email", text: "bad", errorText: "Invalid email"))
        XCTAssertNotNil(field.fui_visibleLabel(text: "Invalid email"))
        // The well's border turns to the error color.
        let well = field.fui_subviews(ofType: UIView.self).first { $0.layer.borderWidth > 0 }
        XCTAssertEqual(well?.layer.borderColor, FUIColor.error.cgColor)
    }

    func testTextFieldNoErrorUsesLineBorder() {
        let field = FUITextField()
        field.configure(with: .init(label: "Email", text: "ok@x.com", errorText: nil))
        let well = field.fui_subviews(ofType: UIView.self).first { $0.layer.borderWidth > 0 }
        XCTAssertEqual(well?.layer.borderColor, FUIColor.line.cgColor)
    }

    func testTextFieldOnTextChangedFires() {
        let field = FUITextField()
        var received: String?
        field.onTextChanged = { received = $0 }
        let textField = field.fui_firstSubview(ofType: UITextField.self)
        textField?.text = "typed"
        textField?.fui_fireActions(for: .editingChanged)
        XCTAssertEqual(received, "typed")
    }

    // MARK: - FUIOtpField

    func testOtpFieldBuildsRequestedNumberOfCells() {
        let otp = FUIOtpField()
        otp.configure(with: .init(length: 4))
        // Each visible cell carries exactly one digit UILabel.
        XCTAssertEqual(otp.fui_subviews(ofType: UILabel.self).count, 4)
    }

    func testOtpFieldDefaultLengthIsSix() {
        let otp = FUIOtpField()
        otp.configure(with: .init())
        XCTAssertEqual(otp.fui_subviews(ofType: UILabel.self).count, 6)
    }

    func testOtpFieldClampsLengthToAtLeastOne() {
        let otp = FUIOtpField()
        otp.configure(with: .init(length: 0))
        XCTAssertEqual(otp.fui_subviews(ofType: UILabel.self).count, 1)
    }

    // MARK: - FUIPageControl

    func testPageControlReflectsConfiguration() {
        let pager = FUIPageControl()
        pager.configure(with: .init(numberOfPages: 5, currentPage: 2))
        let pc = pager.fui_firstSubview(ofType: UIPageControl.self)
        XCTAssertEqual(pc?.numberOfPages, 5)
        XCTAssertEqual(pc?.currentPage, 2)
    }

    func testPageControlOnPageChangeFires() {
        let pager = FUIPageControl()
        pager.configure(with: .init(numberOfPages: 3, currentPage: 0))
        var changed: Int?
        pager.onPageChange = { changed = $0 }
        let pc = pager.fui_firstSubview(ofType: UIPageControl.self)
        pc?.currentPage = 1
        pc?.fui_fireActions(for: .valueChanged)
        XCTAssertEqual(changed, 1)
    }
}
