'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "859f2c8aba55c57842570ffa86613154",
"version.json": "0e26decff0390bd327309cdc28beed3c",
"icon.png": "69466c921dfc8c178b7d7637795cec18",
"splash/img/light-2x.png": "da93fcd65befe84bd273fdf8a1f257e7",
"splash/img/dark-4x.png": "73fd412e559a31115bd74bfa186f4b52",
"splash/img/light-3x.png": "b0ad55d1faf9cba283b1300cfa2b3a86",
"splash/img/dark-3x.png": "b0ad55d1faf9cba283b1300cfa2b3a86",
"splash/img/light-4x.png": "73fd412e559a31115bd74bfa186f4b52",
"splash/img/dark-2x.png": "da93fcd65befe84bd273fdf8a1f257e7",
"splash/img/dark-1x.png": "ead3654f78d5e3e066ec392a8171206a",
"splash/img/light-1x.png": "ead3654f78d5e3e066ec392a8171206a",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"splash/style.css": "8632f66b778ab6afb1cdff5a5d50857a",
"index.html": "d883a91e369102ac43ca43e863bfaa4b",
"/": "d883a91e369102ac43ca43e863bfaa4b",
"main.dart.js": "e4c323c8e50fab19887bfd75d00f97c1",
"flutter.js": "f31737fb005cd3a3c6bd9355efd33061",
"icons/Icon-192.png": "1d7e82e645ce13e75225ae4f4fc3fa5b",
"icons/Icon-maskable-192.png": "1d7e82e645ce13e75225ae4f4fc3fa5b",
"icons/Icon-maskable-512.png": "821f6370c127e05a8c58718f9ee80b8f",
"icons/Icon-512.png": "821f6370c127e05a8c58718f9ee80b8f",
"manifest.json": "d89b0899bace2d74724eb3c6df2ab7f7",
"assets/AssetManifest.json": "50891adeb566c8bd0342ff157782de5c",
"assets/NOTICES": "8b5c915211ac388c175f33545bd6ac5a",
"assets/FontManifest.json": "1491b69c533263a9381b04d8df5fd3ef",
"assets/AssetManifest.bin.json": "c2ded004041761d6624bdc2757df772e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "ac3807384654c0f90a27d1c3bdaa4b26",
"assets/fonts/MaterialIcons-Regular.otf": "70a5af2e366b9df4a1a9d7ca2333cf05",
"assets/assets/geojson/korea_sigungu.geojson": "3c4f6c2c1c1a1188b4b38715672941d7",
"assets/assets/icon.png": "69466c921dfc8c178b7d7637795cec18",
"assets/assets/images/main_page_bg.png": "5035c401c1bf5dac2dfa37120af6c9df",
"assets/assets/images/2%2525_ex.png": "1cc91b1d0bfcff099d8c67ab2ad7c99e",
"assets/assets/images/side_nav_box.png": "7fbdf0faad0609d9fa3ffa862c371ca5",
"assets/assets/logo/direction.png": "c02f96e4f8f46acfd35527821ac58156",
"assets/assets/logo/earth_logo.png": "bfffa4277e5bcf05348aa820557ff936",
"assets/assets/logo/pm_logo.png": "0781455aa4be53000a09e855a333124c",
"assets/assets/logo/direction.svg": "f3093743acd46dd85596b2f128038e36",
"assets/assets/logo/tab_logo.png": "5efb1d3b5ce25ff10d05372f526a497b",
"assets/assets/logo/onboarding_logo.png": "5035c401c1bf5dac2dfa37120af6c9df",
"assets/assets/logo/sun_logo.png": "be5faf6797b4fefd6fa3d5bddbe65df0",
"assets/assets/icons/main_scenario.svg": "fb040d5b0616db68019f1a36b62bc9ec",
"assets/assets/icons/main_health_effects.svg": "0b430812b43996e317a232b1539f0a8e",
"assets/assets/icons/reset.svg": "bc78a07624aa5244058be9a88267c3b9",
"assets/assets/icons/home.svg": "404a2040b70e77c26db4465a60b42531",
"assets/assets/icons/scenario.svg": "e152289c35528b6359b1c1917e616ffe",
"assets/assets/icons/health_projection.svg": "085d6f65fc3ea393d31f35fe190bbf90",
"assets/assets/icons/right_arrow.svg": "4df77224c5ec4167b60e85b07bfb12ac",
"assets/assets/icons/check.svg": "90ea0728d7170cec5c5f47d4f3022fa1",
"assets/assets/icons/down_arrow.svg": "84ac9140344b0e24a1c77f98291eefd0",
"assets/assets/icons/check_main.svg": "f7d23ea1733a901e9ad902cf5405a917",
"assets/assets/icons/health_effects.svg": "47e13f3e7fe57f7c097d94966787f4ff",
"assets/assets/icons/main_health_projection.svg": "bd9a684bc3e7dc03c48b30ecbffe6ac4",
"assets/assets/icons/main_exposure.svg": "7667b60d73cc4edaa2f5e717ff02b8eb",
"assets/assets/icons/exposure.svg": "1ec993a3dc7e65612ec644f1d76e3737",
"assets/assets/icons/print.svg": "5ba6dea6b23203647301a5ae88aae3da",
"assets/assets/font/Inter-Medium.ttf": "ed533866b5c83114c7dddbcbc2288b19",
"assets/assets/font/Inter-Light.ttf": "d55f45d07cfe01e8797bd1566561f718",
"assets/assets/font/GothicA1-Regular.ttf": "be717b1c4a0d2489626ea59c48df621e",
"assets/assets/font/GothicA1-Light.ttf": "8c47ceaef121e6229ed0cebe64d11dee",
"assets/assets/font/GothicA1-Thin.ttf": "fc466edfd2ff012a0af50580f0320594",
"assets/assets/font/Inter-Thin.ttf": "2dce622147cace7b467d9929b7708430",
"assets/assets/font/Inter-Bold.ttf": "275bfea5dc74c33f51916fee80feae67",
"assets/assets/font/GothicA1-Bold.ttf": "52f7cd17421900c6da27a0b08c82af33",
"assets/assets/font/GothicA1-ExtraBold.ttf": "a185c09926e7bfb5a960bc997437445e",
"assets/assets/font/Inter-Regular.ttf": "079af0e2936ccb99b391ddc0bbb73dcb",
"assets/assets/font/Inter-ExtraBold.ttf": "c9709fb8e32755490795ce5bd226c3a0",
"assets/assets/font/GothicA1-Medium.ttf": "465b59706f7e9f18729d92ea1b813d32",
"assets/assets/font/GothicA1-Black.ttf": "d0a177df589b2918afe920d37020d756",
"assets/assets/font/GothicA1-SemiBold.ttf": "0b1aef2be46d737e07db61fa9eb509b3",
"assets/assets/font/Inter-Black.ttf": "980c7e8757e741bb49c7c96513924c61",
"assets/assets/font/Inter-SemiBold.ttf": "07a48beb92b401297a76ff9f6aedd0ed",
"canvaskit/skwasm.js": "9fa2ffe90a40d062dd2343c7b84caf01",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "87325e67bf77a9b483250e1fb1b54677",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "5fda3f1af7d6433d53b24083e2219fa0",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
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
