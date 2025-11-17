# How to Complete Your Report PDF

## Step 1: Take Screenshots

Your Flutter app is currently running on the emulator. Take these screenshots:

### Screenshot 1: Initial View
1. Make sure your student index "194174" is visible in the input field
2. Ensure the derived coordinates are shown (Lat: 6.90°, Lon: 83.10°)
3. Take screenshot (on macOS: Cmd+Shift+4 and select emulator window)

### Screenshot 2: Weather Data with URL
1. Click the "Fetch Weather" button in the app
2. Wait for weather data to load
3. Expand the "Request Details" section to show the full API URL
4. Make sure these are visible:
   - Temperature
   - Wind speed
   - Weather code
   - Last updated time
   - **Full API request URL**
5. Take screenshot

### Screenshot 3: Cached Data (Optional but recommended)
1. Turn off WiFi/disconnect internet on your Mac
2. Force close and restart the app
3. Notice the orange "CACHED" badge appears
4. Take screenshot showing offline functionality

## Step 2: Create the PDF Report

### Option A: Using Pages (macOS)
1. Open the Markdown file: `report_194174.md`
2. Copy the content
3. Open Pages
4. Create new document
5. Paste content and format nicely
6. Insert screenshots at appropriate sections
7. Export as PDF: File → Export To → PDF
8. Save as `report_194174.pdf`

### Option B: Using Word/Google Docs
1. Open Microsoft Word or Google Docs
2. Copy content from `report_194174.md`
3. Format the document:
   - Use headers (Title, H1, H2)
   - Format code blocks with monospace font
   - Add screenshots
4. Export/Save as PDF: `report_194174.pdf`

### Option C: Using Online Markdown to PDF Converter
1. Go to: https://www.markdowntopdf.com/ or https://md2pdf.netlify.app/
2. Upload `report_194174.md`
3. Download the generated PDF
4. Add screenshots using PDF editor

### Option D: Using Command Line (if you have pandoc)
```bash
# Install pandoc if not installed
brew install pandoc

# Convert to PDF
pandoc report_194174.md -o report_194174.pdf --pdf-engine=xelatex
```

## Step 3: Keep It Under 2 Pages

Your report includes:
1. ✅ Student Index: 194174B
2. ✅ Formula explanation (how coordinates are derived)
3. ✅ Calculated coordinates (6.90°, 83.10°)
4. ✅ Screenshots showing:
   - App interface
   - Weather data
   - Request URL visible
5. ✅ Reflection (3-5 sentences about what you learned and challenges)

### Sample Condensed 2-Page Format:

**Page 1:**
- Title & Student Index
- Coordinate Derivation Formula
- Screenshot 1: App with coordinates
- Screenshot 2: Weather data with visible URL

**Page 2:**
- Features implemented (brief bullet points)
- Reflection (3-5 sentences)
- Conclusion

## Key Points for Your Reflection (3-5 sentences):

Use this template or write your own:

> "During this assignment, I gained hands-on experience with Flutter mobile development and REST API integration. I learned how to implement state management, handle asynchronous operations, and create a Material Design UI. The main challenge I faced was updating the Android SDK version to resolve dependency conflicts. I also learned the importance of error handling and offline caching to provide a seamless user experience. This project demonstrated how mobile apps can remain functional even without constant internet connectivity."

## Tips for 2-Page Limit:
- Use smaller font for code snippets (9-10pt)
- Keep screenshots compact (resize if needed)
- Focus on essentials: formula, coordinates, screenshots, reflection
- Remove unnecessary sections if space is tight
- Use 0.5" margins
- Single spacing for code blocks

## Final Checklist:
- [ ] Student index visible in document: 194174B
- [ ] Formula clearly explained
- [ ] Coordinates calculated: Lat 6.90°, Lon 83.10°
- [ ] Screenshot(s) included with request URL visible
- [ ] 3-5 sentence reflection included
- [ ] File saved as: `report_194174.pdf`
- [ ] Document is 2 pages or less
- [ ] PDF is readable and well-formatted

---

Good luck with your submission! 🎉
