# Arcoffee — PHP Laravel REST API Endpoints Specification

This document details the expected JSON payload contracts, HTTP methods, query parameters, and response schemas required by the **Arcoffee Flutter Web** frontend from the **PHP Laravel** backend.

---

## 🌐 Base URL & Common Headers

* **Base URL:** `https://api.arcoffee.ph/api/v1` (Production) or `http://localhost:8000/api/v1` (Local Dev)
* **Default Request Headers:**
  ```http
  Accept: application/json
  Content-Type: application/json
  X-Requested-With: XMLHttpRequest
  X-Client-Platform: Flutter-Web-Cupertino
  X-App-Version: 1.0.0
  ```

---

## 1. Menu Endpoints

### 1.1 List Menu Items
* **Endpoint:** `GET /api/v1/menu`
* **Query Parameters:**
  | Parameter | Type | Required | Description | Example |
  | :--- | :--- | :--- | :--- | :--- |
  | `category` | string | Optional | Category slug: `coffee`, `non-coffee`, `soda-series`, `matcha-series`, `all` | `matcha-series` |
  | `search` | string | Optional | Case-insensitive substring search for name, description, or tags | `haw-haw` |

* **Success Response (HTTP 200 OK):**
```json
{
  "data": [
    {
      "id": "c1",
      "name": "Spanish Latte",
      "description": "Velvety espresso paired with condensed milk and creamy textured milk. The ultimate courtside crowd pleaser.",
      "category_slug": "coffee",
      "price": 130.0,
      "formatted_price": "₱130",
      "is_bestseller": true,
      "is_court_favorite": true,
      "is_new": false,
      "tags": ["Bestseller", "Courtside Favorite", "Sweet & Creamy"],
      "size": "16 oz Iced",
      "caffeine_note": "High Caffeine"
    },
    {
      "id": "c3",
      "name": "Arcoffee Cold Brew Reserve",
      "description": "Slow-steeped for 18 hours using high-altitude Arabica beans. Notes of dark cacao, roasted nuts, and subtle brown sugar.",
      "category_slug": "coffee",
      "price": 125.0,
      "formatted_price": "₱125",
      "is_bestseller": false,
      "is_court_favorite": true,
      "is_new": false,
      "tags": ["18h Steeped", "Clean Finish", "Pickleball Fuel"],
      "size": "16 oz Cold Bottle",
      "caffeine_note": "Very High Caffeine"
    },
    {
      "id": "nc1",
      "name": "Milo Overload",
      "description": "A nostalgic malt chocolate mountain featuring rich chocolate base, malt cream, and heaping mounds of raw Milo powder.",
      "category_slug": "non-coffee",
      "price": 135.0,
      "formatted_price": "₱135",
      "is_bestseller": true,
      "is_court_favorite": true,
      "is_new": false,
      "tags": ["Bestseller", "Nostalgic", "Crowd Hit"],
      "size": "16 oz Iced",
      "caffeine_note": "Caffeine-Free"
    },
    {
      "id": "nc2",
      "name": "Ovaltine Rush",
      "description": "Toasted malt goodness blended with creamy Hokkaido milk, chocolate drizzle, and crunchy malt crunchies.",
      "category_slug": "non-coffee",
      "price": 135.0,
      "formatted_price": "₱135",
      "is_bestseller": true,
      "is_court_favorite": false,
      "is_new": false,
      "tags": ["Crunchy Texture", "Malt Infusion"],
      "size": "16 oz Iced",
      "caffeine_note": "Caffeine-Free"
    },
    {
      "id": "s1",
      "name": "Lychee Sparkler",
      "description": "Floral lychee syrup infused with effervescent carbonation, crushed ice, and fresh mint leaves. Crisp and invigorating.",
      "category_slug": "soda-series",
      "price": 120.0,
      "formatted_price": "₱120",
      "is_bestseller": true,
      "is_court_favorite": true,
      "is_new": false,
      "tags": ["Post-Match Refresher", "Fizzy", "Floral"],
      "size": "16 oz Iced Sparkler",
      "caffeine_note": "Zero Caffeine"
    },
    {
      "id": "s2",
      "name": "Green Apple Fizz",
      "description": "Crisp green Granny Smith apple infusion charged with sparkling bubbles and a hint of tart lime juice.",
      "category_slug": "soda-series",
      "price": 120.0,
      "formatted_price": "₱120",
      "is_bestseller": false,
      "is_court_favorite": true,
      "is_new": false,
      "tags": ["Tart & Crisp", "Hydrating", "Pickleball Favorite"],
      "size": "16 oz Iced Sparkler",
      "caffeine_note": "Zero Caffeine"
    },
    {
      "id": "s3",
      "name": "Lemon Yuzu Spritz",
      "description": "Zesty Japanese yuzu paired with fresh lemon reduction, sparkling soda water, and citrus peels. High vitality.",
      "category_slug": "soda-series",
      "price": 130.0,
      "formatted_price": "₱130",
      "is_bestseller": true,
      "is_court_favorite": false,
      "is_new": false,
      "tags": ["Citrus Punch", "Electrolytes", "Bestseller"],
      "size": "16 oz Iced Sparkler",
      "caffeine_note": "Zero Caffeine"
    },
    {
      "id": "m1",
      "name": "Haw-Haw Matcha",
      "description": "Our viral signature creation! Traditional ceremonial Uji matcha fused with the nostalgic milky sweet flavor of iconic Haw-Haw candy.",
      "category_slug": "matcha-series",
      "price": 160.0,
      "formatted_price": "₱160",
      "is_bestseller": true,
      "is_court_favorite": true,
      "is_new": false,
      "tags": ["Viral Signature", "Haw-Haw Milk", "Cavite Exclusive"],
      "size": "16 oz Iced",
      "caffeine_note": "Clean L-Theanine Energy"
    },
    {
      "id": "m2",
      "name": "Matcha Drift",
      "description": "Whisked ceremonial green tea poured over chilled sweet milk and topped with an airy, cloud-like matcha cold foam drift.",
      "category_slug": "matcha-series",
      "price": 155.0,
      "formatted_price": "₱155",
      "is_bestseller": true,
      "is_court_favorite": false,
      "is_new": false,
      "tags": ["Matcha Cold Foam", "Ceremonial Grade"],
      "size": "16 oz Iced",
      "caffeine_note": "Medium L-Theanine"
    }
  ]
}
```

---

### 1.2 Get Menu Item Details
* **Endpoint:** `GET /api/v1/menu/{id}`
* **Success Response (HTTP 200 OK):**
```json
{
  "data": {
    "id": "m1",
    "name": "Haw-Haw Matcha",
    "description": "Our viral signature creation! Traditional ceremonial Uji matcha fused with the nostalgic milky sweet flavor of iconic Haw-Haw candy.",
    "category_slug": "matcha-series",
    "price": 160.0,
    "formatted_price": "₱160",
    "is_bestseller": true,
    "is_court_favorite": true,
    "is_new": false,
    "tags": ["Viral Signature", "Haw-Haw Milk", "Cavite Exclusive"],
    "size": "16 oz Iced",
    "caffeine_note": "Clean L-Theanine Energy"
  }
}
```
* **Error Response (HTTP 404 Not Found):**
```json
{
  "message": "Drink item not found."
}
```

---

### 1.3 Featured Highlights
* **Endpoint:** `GET /api/v1/menu/featured`
* **Success Response (HTTP 200 OK):**
Returns an array of drinks where `is_bestseller = true` or `is_court_favorite = true`.

---

## 2. Store & Venue Endpoints

### 2.1 Get Store Information & Hours
* **Endpoint:** `GET /api/v1/store`
* **Success Response (HTTP 200 OK):**
```json
{
  "data": {
    "name": "Arcoffee",
    "slogan": "It's always been ours.",
    "venue": "The Pickleground PH",
    "address": "Advincula Ave, boundary of Kawit and Noveleta",
    "province": "Cavite, Philippines",
    "weekday_hours": "Mon – Thu: 2:00 PM – 10:00 PM",
    "weekend_hours": "Fri – Sun: 24 Hours Non-Stop",
    "phone": "+63 917 552 2726",
    "email": "contact@arcoffee.ph",
    "instagram": "@arcoffee.ph",
    "facebook": "facebook.com/arcoffeeph",
    "court_amenities": [
      "Regulation Pickleball Courts",
      "24-Hour Weekend Games",
      "Courtside Viewing Deck",
      "High-Speed Wi-Fi",
      "Device Charging Hubs",
      "Pet Friendly Patio",
      "Dedicated Free Parking",
      "Post-Game Recovery Drinks"
    ],
    "is_open_24_hours_weekend": true
  }
}
```

### 2.2 Live Open/Closed Status
* **Endpoint:** `GET /api/v1/store/status`
* **Success Response (HTTP 200 OK):**
```json
{
  "data": {
    "is_open": true,
    "current_shift": "24h Weekend Tournament Session",
    "timestamp": "2026-09-22T01:45:00Z"
  }
}
```

---

## 3. Community Gallery Endpoints

### 3.1 Get Community Feed
* **Endpoint:** `GET /api/v1/gallery`
* **Success Response (HTTP 200 OK):**
```json
{
  "data": [
    {
      "id": "g1",
      "title": "Midnight Rallies & Espresso",
      "category": "Court Action",
      "subtitle": "Full court lighting during our 24-hour weekend session at The Pickleground.",
      "height_ratio": 1.25,
      "likes_count": "482",
      "timestamp": "Friday Night Run"
    },
    {
      "id": "g2",
      "title": "Haw-Haw Matcha Drift",
      "category": "Drink Spotlight",
      "subtitle": "The original nostalgic fusion. Freshly poured right before a tournament match.",
      "height_ratio": 1.0,
      "likes_count": "629",
      "timestamp": "Just now"
    },
    {
      "id": "g3",
      "title": "Courtside Community Chill",
      "category": "Community",
      "subtitle": "Friends cooling off with Lychee Sparklers and Milo Overload after game 3.",
      "height_ratio": 1.35,
      "likes_count": "315",
      "timestamp": "Saturday Afternoon"
    }
  ]
}
```

### 3.2 Like a Gallery Post
* **Endpoint:** `POST /api/v1/gallery/{id}/like`
* **Success Response (HTTP 200 OK):**
```json
{
  "liked": true,
  "likes_count": 483
}
```

---

## 4. Laravel Backend Reference Implementation

### `routes/api.php`
```php
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\Api\StoreController;
use App\Http\Controllers\Api\GalleryController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::get('/menu', [MenuController::class, 'index']);
    Route::get('/menu/featured', [MenuController::class, 'featured']);
    Route::get('/menu/{id}', [MenuController::class, 'show']);

    Route::get('/store', [StoreController::class, 'show']);
    Route::get('/store/status', [StoreController::class, 'status']);

    Route::get('/gallery', [GalleryController::class, 'index']);
    Route::post('/gallery/{id}/like', [GalleryController::class, 'like']);
});
```

### `app/Http/Controllers/Api/MenuController.php`
```php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\MenuItemResource;
use App\Models\MenuItem;
use Illuminate\Http\Request;

class MenuController extends Controller
{
    public function index(Request $request)
    {
        $query = MenuItem::query();

        if ($request->filled('category') && $request->category !== 'all') {
            $query->where('category_slug', $request->category);
        }

        if ($request->filled('search')) {
            $search = strtolower($request->search);
            $query->where(function ($q) use ($search) {
                $q->whereRaw('LOWER(name) LIKE ?', ["%{$search}%"])
                  ->orWhereRaw('LOWER(description) LIKE ?', ["%{$search}%"]);
            });
        }

        return MenuItemResource::collection($query->get());
    }

    public function show($id)
    {
        $item = MenuItem::findOrFail($id);
        return new MenuItemResource($item);
    }

    public function featured()
    {
        $items = MenuItem::where('is_bestseller', true)
            ->orWhere('is_court_favorite', true)
            ->take(6)
            ->get();

        return MenuItemResource::collection($items);
    }
}
```
