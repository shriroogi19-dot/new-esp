# Alcohol Detection Website (Vercel + GitHub)

Folder structure (keep it exactly like this):

    index.html            the website (shown at your main link)
    api/send-sms.js       sends SMS + saves to database
    api/alerts.js         alert history from database
    api/contacts.js       contacts stored in database
    api/health.js         status check
    api/_db.js            database helper
    schema.sql            SQL tables (run once in your database)
    package.json          dependencies
    .env.example          list of settings you add in Vercel

## 1. Put it on GitHub
1. Unzip the downloaded file. Open the folder `vercel-alcohol`.
2. On github.com click New repository, give it a name, click Create.
3. Click "uploading an existing file".
4. Select EVERYTHING inside the `vercel-alcohol` folder (index.html, api, package.json, schema.sql, README.md, .gitignore, .env.example) and drag it into the page. `index.html` and the `api` folder must be at the TOP of the repo (not inside another folder).
5. Click Commit changes.

## 2. Deploy on Vercel
1. Go to vercel.com > Add New > Project > import your GitHub repository.
2. Framework Preset: Other. Leave Build Command and Output Directory empty.
3. Before clicking Deploy, open Environment Variables and add:
   - SMS_PROVIDER = fast2sms   (or twilio / console for testing)
   - FAST2SMS_API_KEY = your key
   - ACCESS_CODE = any secret word you choose
   - DATABASE_URL = your PostgreSQL connection string (see step 3)
4. Click Deploy. If you add variables later, go to Deployments > Redeploy.

## 3. Database (optional but recommended)
1. Create a free PostgreSQL database at neon.tech (or Vercel > Storage).
2. Open its SQL editor, paste all of schema.sql, run it.
3. Copy its connection string into the DATABASE_URL variable on Vercel.

## 4. Use it
Open your https://....vercel.app link in Chrome (Android phone or PC).
In the site settings type the same ACCESS_CODE, add phone numbers, press "Send test SMS",
then connect to the ESP32 with Bluetooth LE (or the Serial button on a PC).
Keep the page open near the car. iPhone/Safari does not support Web Bluetooth.

Extra API links: /api/health  /api/alerts  /api/contacts

## If you see 404 NOT_FOUND
- Open your GitHub repo: index.html and the api folder must be visible on the first page. If you only see one folder (e.g. vercel-alcohol), either re-upload the files from inside it, or in Vercel > Project > Settings > General set Root Directory to that folder, then Redeploy.
- Settings > General: Framework Preset = Other, Output Directory = empty (turn the override off).
