# Explainer: Text Detection API

## Introduction

The **Text Detection API** enables web applications to detect and recognize text within images, video frames, canvas elements, and other image sources. As part of the broader [WICG Shape Detection API](https://wicg.github.io/shape-detection-api/text.html) initiative, this API exposes a standardized, high-performance text detection interface directly through the Web Platform.

Extracting textual information from visual media (Optical Character Recognition, or OCR) is a critical requirement across many modern web experiences—such as document scanning, receipt processing, live camera text extraction, image translation, and assistive reading tools.

---

## Problem Statement & Alternatives Today

Today, web developers needing to detect text in images must choose between two approaches, each carrying substantial tradeoffs:

### 1. Bundling Client-Side Third-Party Libraries (e.g., WebAssembly / JavaScript OCR)
- **Bandwidth and Payload Overhead:** Full OCR engines require packaging neural network models, dictionaries, and WebAssembly runtimes. Shipping these bundles requires downloading tens of megabytes over the network, dramatically inflating initial page load times and consuming costly mobile bandwidth.
- **CPU, Memory, and Battery Drain:** Executing unoptimized OCR models inside JavaScript or WebAssembly worker threads heavily taxes CPU cores and memory, leading to frame drops, thermal throttling, and battery drain on mobile and laptop devices.
- **Limited Access to Hardware Acceleration:** Web content cannot directly leverage platform-level vision pipelines or hardware accelerators.

### 2. Using Remote Cloud Vision Services
- **Network Latency:** Uploading high-resolution images or camera frames to a remote cloud API introduces round-trip network delays, making interactive or live viewfinder experiences sluggish.
- **Infrastructure and Financial Cost:** Running or subscribing to cloud vision endpoints incurs ongoing hosting and API costs that increase linearly with application usage.
- **Offline Limitations:** Cloud-based recognition fails completely in low-connectivity, intermittent, or offline environments.
- **Privacy and Data Residency:** Sending sensitive user images—such as receipts, identity documents, bank statements, or private photos—over the network introduces privacy concerns and adds compliance overhead regarding data residency and user consent.

---

## Benefits of a Browser-Provided API

A native Web Platform Text Detection API addresses these challenges by offering:

- **Zero Payload Overhead:** The capability is provided by the browser environment, eliminating the need for web applications to bundle and distribute large model weights or runtimes.
- **Optimized Performance:** Browsers can integrate directly with platform-level acceleration, executing text recognition with high efficiency and lower power consumption than user-space scripts.
- **Privacy by Default:** Image data remains within the browser's execution boundary, removing the requirement to transmit user documents or camera feeds across the network to third-party endpoints.

---

## API Design

The API is exposed in `Window` and `DedicatedWorker` contexts within secure contexts (`https://`).

### Web IDL

```webidl
[
    Exposed=(Window,DedicatedWorker),
    SecureContext
] interface TextDetector {
    // Asynchronously initializes the detector and confirms that any underlying
    // platform resources, models, or services are ready before resolving.
    static Promise<TextDetector> create();

    // Detects text in an image source.
    Promise<sequence<DetectedText>> detect(ImageBitmapSource image);
};

dictionary DetectedText {
    required DOMString rawValue;
    required DOMRectReadOnly boundingBox;
    required sequence<Point2D> cornerPoints;
};

dictionary Point2D {
    required unrestricted double x;
    required unrestricted double y;
};
```

### Asynchronous Initialization (`TextDetector.create()`)

`TextDetector.create()` initializes the detector and verifies that underlying platform resources or models are available and ready before resolving:

- **Readiness Verification:** Returns a `Promise<TextDetector>` that resolves once the detector engine is ready. If the host environment lacks text detection capabilities or if initialization fails, the promise rejects with a `NotSupportedError` DOMException.
- **Predictable Error Handling:** Web applications can verify support and readiness up front (e.g., before requesting camera permissions or accepting file uploads) and present appropriate fallback user interfaces.

---

## Example Usage

### 1. Basic Text Detection

```javascript
// Check for feature availability
if ('TextDetector' in globalThis) {
  try {
    // Asynchronously create and verify detector readiness
    const detector = await TextDetector.create();

    const imageElement = document.getElementById('scanned-doc');
    const detectedTexts = await detector.detect(imageElement);

    for (const text of detectedTexts) {
      console.log(`Detected: "${text.rawValue}"`);
      console.log(`Bounding Box: [x: ${text.boundingBox.x}, y: ${text.boundingBox.y}, ` +
                  `w: ${text.boundingBox.width}, h: ${text.boundingBox.height}]`);
    }
  } catch (err) {
    console.warn('Text detection failed to initialize or detect:', err);
  }
} else {
  console.log('Text Detection API is not supported in this browser.');
}
```

### 2. Live Camera Viewfinder with Oriented Overlays

```javascript
const video = document.getElementById('camera-preview');
const canvas = document.getElementById('overlay-canvas');
const ctx = canvas.getContext('2d');

// Initialize the camera stream
video.srcObject = await navigator.mediaDevices.getUserMedia({ video: true });
await video.play();

const detector = await TextDetector.create();

async function processFrame() {
  if (video.readyState >= HTMLMediaElement.HAVE_CURRENT_DATA) {
    const results = await detector.detect(video);

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    for (const item of results) {
      // Draw oriented polygon around text using cornerPoints
      const [tl, tr, br, bl] = item.cornerPoints;
      ctx.beginPath();
      ctx.moveTo(tl.x, tl.y);
      ctx.lineTo(tr.x, tr.y);
      ctx.lineTo(br.x, br.y);
      ctx.lineTo(bl.x, bl.y);
      ctx.closePath();

      ctx.lineWidth = 2;
      ctx.strokeStyle = '#00E676';
      ctx.stroke();

      // Display detected text
      ctx.font = '14px sans-serif';
      ctx.fillStyle = '#00E676';
      ctx.fillText(item.rawValue, tl.x, tl.y - 4);
    }
  }
  requestAnimationFrame(processFrame);
}

requestAnimationFrame(processFrame);
```

### 3. Offloading Processing to a Web Worker

```javascript
// worker.js
let detector = null;

self.onmessage = async (event) => {
  const { imageBitmap } = event.data;

  if (!detector) {
    detector = await TextDetector.create();
  }

  const results = await detector.detect(imageBitmap);
  imageBitmap.close(); // Clean up transferable resource

  self.postMessage({ results });
};
```

---

## Example Use Cases

1. **Document & Receipt Scanning:**
   Expense trackers and financial applications can extract vendor names, totals, and line items from camera images without uploading unencrypted receipts to external cloud servers.
2. **Real-World Text Interaction:**
   Translators, dictionary lookups, and travel tools can translate signs, menus, and printed text in real time directly from camera feeds.
3. **Form Autofill & Verification:**
   Capturing tracking numbers, serial numbers, IBANs, or physical addresses from physical cards or packaging to automatically populate web forms.
4. **Accessibility & Assistive Reading:**
   Making text embedded inside images, screenshots, charts, and canvas drawings readable and searchable for screen readers and assistive technologies.
5. **Interactive Video & Canvas Annotations:**
   Locating subtitles or graphical text inside video streams to enable in-video search and selectable text highlights.

---

## Future Work & Potential Extensions

The initial specification prioritizes a minimal, robust API surface (`create()` and `detect()`) that can be implemented cleanly across diverse operating systems and browser engines. Future revisions may explore several natural extensions:

### 1. Language Negotiation & Availability Checking
While modern vision engines often recognize multilingual text automatically, applications operating in specialized or resource-sensitive environments may benefit from querying language support in advance or hinting preferred languages:

```webidl
enum Availability {
    "unavailable",
    "downloadable",
    "downloading",
    "available"
};

dictionary TextDetectorOptions {
    required sequence<DOMString> languages; // BCP-47 language tags
};

dictionary TextDetectorCreateOptions {
    sequence<DOMString> languages;
    AbortSignal signal;
};

partial interface TextDetector {
    static Promise<Availability> availability(TextDetectorOptions options);
    static Promise<TextDetector> create(optional TextDetectorCreateOptions options = {});
};
```

This would allow web applications to query whether specific language packs (e.g., `["ja", "ko"]`) are readily available or require on-demand downloads before initiating recognition.

### 2. Structural Hierarchy (Blocks, Lines, Words)
The initial API returns recognized text segments at the line level. Future extensions could optionally expose hierarchical segmentation—such as identifying paragraphs, lines, and individual word bounding boxes—to assist advanced document editors and in-place translation overlays.

---

## Privacy & Security Considerations

- **Secure Contexts Only:** The `TextDetector` interface is restricted to Secure Contexts (`HTTPS`), preventing person-in-the-middle tampering and eavesdropping.
- **Cross-Origin Image Protection (CORS):** To prevent unauthorized reading of cross-origin visual data, `detect()` enforces the same-origin policy on all `ImageBitmapSource` inputs. Passing a cross-origin image or video that has not been granted CORS access rejects the promise with a `SecurityError` DOMException.
- **Data Confidentiality:** Unlike cloud-based OCR services, the API allows text recognition to occur within the browser without transmitting user images or recognition results across network boundaries.


