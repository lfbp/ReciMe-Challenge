# ReciMe

A native iOS recipe browser built with **Swift**, **SwiftUI**, and **Combine**. Users can log in (mock auth), search and filter recipes, open details, and save favorites.

---

## Features

- Mock login
- Browse recipes (mock API backed by local JSON)
- Search by text (title, description, cuisine, ingredients)
- Filter by dietary tags, difficulty, cuisine, servings, and prep time
- Recipe detail (ingredients + instructions)
- Favorites tab with local persistence (`UserDefaults`)
- Observability for user actions, API results, and view impressions

---

## How to run & login

1. Open `ReciMeProject/ReciMeProject.xcodeproj` in Xcode
2. Pick an iPhone simulator
3. Run (⌘R)
4. On the login screen, enter **any non-empty username and password**
5. Tap **Login** — you land on the Recipes / Favorites tabs

There is no real backend. Credentials are only checked for emptiness.

---

## Architecture overview

The app uses **MVVM-C** (Model–View–ViewModel + Coordinators) with **constructor dependency injection**.

```
ReciMeProjectApp
  └─ AppDependencies          ← composition root (lazy services)
  └─ AppCoordinator           ← app routes: login | main
        ├─ LoginCoordinator   ← LoginDependencies only
        └─ (after login)
              ├─ RecipeListCoordinator  ← HomeTabDependencies
              └─ FavoritesCoordinator   ← HomeTabDependencies
                    └─ RecipeDetail (pushed on each tab’s NavigationStack)
```

### Layers

| Layer | Role |
|---|---|
| **Views** | SwiftUI UI; bind to ViewModels |
| **ViewModels** | State, Combine pipelines, call services |
| **Coordinators** | Navigation and flow wiring; build screens |
| **Services** | Auth, recipes (mock API), favorites storage |
| **AppDependencies** | Creates and owns shared services |

### Dependency injection

- `AppDependencies` is the single composition root
- Feature coordinators receive **narrow protocols** (`LoginDependencies`, `HomeTabDependencies`) so Login cannot access recipe services
- Services are **`lazy`** — created on first use (auth at login; recipes/favorites after login)

### Data flow

```
User action → View → ViewModel → Service (mock API / storage)
                              ↓
                         @Published → View updates
```

Search and filters trigger a **new** `searchRecipes(with:)` call (with loading), not local filtering of an already-loaded list.

---

## Project layout

```
ReciMeProject/
├── App/                 # AppCoordinator
├── Modules/             # Login, RecipeList, RecipeDetail, Favorites, MainTab
├── Core/                # DI, networking, storage, errors
├── DesignSystem/        # UI building blocks
├── ObservabilityKit/    # Analytics / logging / impressions
└── Resources/Data/      # recipes.json
```

---

**Built with Swift, SwiftUI, and Combine**
