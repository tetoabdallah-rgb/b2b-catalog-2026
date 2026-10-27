// Service Worker - 2B Catalog 2026 Enterprise Edition
const CACHE_NAME = 'catalog-2026-v9-live';
const STATIC_ASSETS = [
  './',
  './index.html',
  './manifest.json',
  './icon-192.png',
  './icon-512.png'
];

self.addEventListener('install', (e) => {
  self.skipWaiting();
  e.waitUntil(
    caches.open(CACHE_NAME).then(async (cache) => {
      for (const url of STATIC_ASSETS) {
        try {
          await cache.add(new Request(url, { cache: 'reload' }));
        } catch (err) {
          console.warn('Could not cache asset:', url, err);
        }
      }
    })
  );
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((k) => {
          if (k !== CACHE_NAME) {
            console.log('Purging old service worker cache:', k);
            return caches.delete(k);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Network-First for HTML Navigation (Always fetch latest prices/images if online)
// Cache-First with Background Update for static assets
self.addEventListener('fetch', (e) => {
  if (e.request.method !== 'GET') return;

  const url = new URL(e.request.url);

  // Bypass any obsolete external product_images folder requests
  if (url.pathname.includes('/product_images/')) {
    return;
  }

  const isNavigation = e.request.mode === 'navigate' || url.pathname.endsWith('.html') || url.pathname.endsWith('/');

  if (isNavigation) {
    // NETWORK-FIRST FOR CATALOG HTML:
    // Guarantees merchants immediately get the newly uploaded prices and photos!
    e.respondWith(
      fetch(e.request, { cache: 'no-cache' })
        .then((networkRes) => {
          if (networkRes && networkRes.status === 200) {
            const clone = networkRes.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(e.request, clone));
          }
          return networkRes;
        })
        .catch(() => {
          // If offline or network error, fallback to cached catalog
          return caches.match(e.request).then((cached) => cached || caches.match('./index.html'));
        })
    );
    return;
  }

  // STATIC ASSETS: Stale-While-Revalidate
  e.respondWith(
    caches.match(e.request).then((cachedResponse) => {
      const fetchPromise = fetch(e.request).then((networkRes) => {
        if (networkRes && networkRes.status === 200) {
          const clone = networkRes.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(e.request, clone));
        }
        return networkRes;
      }).catch(() => cachedResponse);

      return cachedResponse || fetchPromise;
    })
  );
});

// Listen for instant skipWaiting request from client
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});
