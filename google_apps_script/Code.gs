/**
 * HarSetu Tech website — Contact Us form handler.
 *
 * Setup:
 * 1. Create/open a Google Sheet.
 * 2. Extensions > Apps Script, delete the boilerplate, paste this whole file.
 * 3. Change NOTIFY_EMAIL below if enquiry emails should go somewhere else.
 * 4. Deploy > New deployment > select type "Web app".
 *      - Execute as: Me
 *      - Who has access: Anyone
 * 5. Click Deploy, authorize the requested permissions, then copy the
 *    "Web app URL" it gives you.
 * 6. Paste that URL into SiteContent.contactFormEndpoint in the Flutter app
 *    (lib/constants/site_content.dart).
 *
 * Each submission appends a row to the "Enquiries" sheet (created
 * automatically on first run) and emails NOTIFY_EMAIL with the details.
 */

const SHEET_NAME = 'Enquiries';
const NOTIFY_EMAIL = 'harsetu51td@gmail.com';

function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);

    const name = (data.name || '').toString().trim();
    const email = (data.email || '').toString().trim();
    const phone = (data.phone || '').toString().trim();
    const message = (data.message || '').toString().trim();
    const subject = (data.subject || 'New Enquiry from Website').toString().trim();

    if (!name || !email || !message) {
      return jsonResponse({ status: 'error', message: 'Missing required fields.' });
    }

    getSheet().appendRow([new Date(), name, email, phone, message]);

    MailApp.sendEmail({
      to: NOTIFY_EMAIL,
      replyTo: email,
      subject: subject,
      body:
        'New enquiry received from the website:\n\n' +
        'Name: ' + name + '\n' +
        'Email: ' + email + '\n' +
        'Phone: ' + phone + '\n\n' +
        'Message:\n' + message,
    });

    return jsonResponse({ status: 'success' });
  } catch (err) {
    return jsonResponse({ status: 'error', message: err.message });
  }
}

function getSheet() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName(SHEET_NAME);
  if (!sheet) {
    sheet = ss.insertSheet(SHEET_NAME);
    sheet.appendRow(['Timestamp', 'Name', 'Email', 'Phone', 'Message']);
  }
  return sheet;
}

function jsonResponse(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(ContentService.MimeType.JSON);
}
