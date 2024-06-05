'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "f17a293d422e2c0b3a04962e68236cc2",
"canvaskit/canvaskit.wasm": "fbbcfde7650164f0d0eb1564b1333f56",
"canvaskit/canvaskit.js.symbols": "0c3f8ba3bd6d389de47ac4ba771c9dc6",
"canvaskit/skwasm.js.symbols": "4142410438d40ea77420b7d9df1f0501",
"canvaskit/skwasm.wasm": "f7ba7fd3fb5396e4fc866246a186cf97",
"canvaskit/canvaskit.js": "5fda3f1af7d6433d53b24083e2219fa0",
"canvaskit/chromium/canvaskit.wasm": "38c5aa23c6f1dcb4c9c29b485385da12",
"canvaskit/chromium/canvaskit.js.symbols": "ee5f10fe667aefb01c922f90f7b84ac6",
"canvaskit/chromium/canvaskit.js": "87325e67bf77a9b483250e1fb1b54677",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "5ff18458653a1a0be2d274b2a989db18",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "32a5a3d7b8e132267726f856a5aa7382",
"version.json": "ce585f91f7173cbb62d163c4fc3e3c79",
"index.html": "b802cc3e8a113003a0d757ce25fdfb25",
"/": "b802cc3e8a113003a0d757ce25fdfb25",
"main.dart.js": "a60f55a8178a9701e9966c40b8161dc0",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/HGSS.ttf": "ec0d8a5623c532b098332da70ecb9451",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/tvN%2520Enjoystories%2520Light.ttf": "2487cfecdc1d45e22b56d6320bf3294a",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/Typo_CrayonM.ttf": "a7c185b823fdbd5ad2a00f25e33044df",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/THE%25EB%25B8%2594%25EB%259E%2599%25EC%259E%25ADL.ttf": "966397cc0c8aed2788169f644f8aad48",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/210%2520Ojunohwhoo%2520L.ttf": "20ef7ab6e833ae3c896553023e73b850",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/SangSangShinb7.otf": "2ebb4867e4758d96657abc059161c8d9",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/210%2520%25EC%258B%259C%25EA%25B3%25A8%25EB%25B0%25A5%25EC%2583%2581L.ttf": "cc1c9e8f7e16b4364179ab4a48225626",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/HoonSlimskinnyL.ttf": "230ba4d30521c37a2ddd2fee0c3246df",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/Typo_TodayWeatherM.ttf": "ca055d1d6f0cc3e2ad3987d262ddaacc",
"assets/lib/%25EC%2598%2588%25EC%2581%259C%25EA%25B8%2580%25EC%2594%25A8%25EC%25B2%25B4/SangSangFlowerRoad.otf": "96dc65dfff5ff11578e2111f990117cf",
"assets/AssetManifest.json": "99f283aff106963f39f54918677962ad",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "b9d8c495d7f6ee2ed31363bf57524fef",
"assets/fonts/MaterialIcons-Regular.otf": "2443ffcdd19a7b20fd603fbf76f11774",
"assets/NOTICES": "4aa3d83a0525ba7eb492c6d675356855",
"assets/AssetManifest.bin": "470afc9397fc36645cf4b6b60b86a55c",
"assets/FontManifest.json": "a5dfc833f71a30904e4592ab2ffadd27",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}