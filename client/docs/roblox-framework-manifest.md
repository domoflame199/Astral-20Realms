Htrea — Roblox Framework: Complete Placement Manifest

Purpose
This single manifest lists every script/module created in the project, where it should be placed inside a Roblox Studio place (exact folder), the type (ModuleScript / Script / LocalScript), short description, and key dependencies. It also includes an end-to-end flow and asset guidance for animations/models.

How to use
- Create folders in Studio matching the "Target Path" column, then add ModuleScripts/Scripts/LocalScripts and paste the code from the matching file in this repository (public/roblox-framework/*).
- Shared code should go into ReplicatedStorage so both client and server can require it safely.
- Server authoritative code belongs under ServerScriptService.
- Client LocalScripts belong in StarterPlayer > StarterPlayerScripts.

==== FILE MANIFEST (by target location) ====

ReplicatedStorage/AstralFramework/Shared (ModuleScript)
- Signal.lua
  • Type: ModuleScript
  • Purpose: lightweight signal helper (BindableEvent wrapper). Use for internal event patterns in modules.
  • Dependencies: none

- Net.lua
  • Type: ModuleScript
  • Purpose: Remote registry. Ensures folders Remotes/Events/Functions exist and provides GetEvent/GetFunction helpers.
  • Dependencies: Instance API

- Config.lua
  • Type: ModuleScript
  • Purpose: Centralized tuning constants (DataStore name, combat tuning, rate limits).
  • Dependencies: none

- Items.lua
  • Type: ModuleScript
  • Purpose: Catalog of items, crafting recipes, and loot tables used by Shop/Crafting/Loot systems.
  • Dependencies: none

- Maid.lua
  • Type: ModuleScript
  • Purpose: Resource/connection cleanup utility. Use per-player and per-NPC to avoid memory leaks.
  • Dependencies: none


ServerScriptService/AstralFramework
- ServiceController.server.lua
  • Type: Script (entry point)
  • Purpose: Bootstraps services. Require this script to start server modules. Creates necessary remotes early.
  • Dependencies: Shared/Net, Shared/Config, and all server modules listed below.

- RateLimiter.server.lua
  • Type: ModuleScript
  • Purpose: Token-bucket rate limiting for per-player action throttling.
  • Dependencies: RunService

- PlayerData.server.lua
  • Type: ModuleScript
  • Purpose: DataStore persistence, autosave loop, schema validation & migrations, Player profile APIs (AddItem, AddGold, HasMaterials, etc.).
  • Dependencies: DataStoreService, Shared/Config

- StatusEffects.server.lua
  • Type: ModuleScript
  • Purpose: Tracks applied statuses, tick/expiry loop, fires StatusApplied/StatusCleared remotes to clients.
  • Dependencies: RunService, Shared/Net

- Combat.server.lua
  • Type: ModuleScript
  • Purpose: Authoritative combat system. Validates range/cooldowns, clamps damage, anti‑cheat checks, and calls Humanoid:TakeDamage.
  • Dependencies: PlayerData, StatusEffects, RateLimiter, Shared/Config

- Arcana.server.lua
  • Type: ModuleScript
  • Purpose: Handle ability casts, cooldown tracking, server-side spawning/notification of projectiles and effects.
  • Dependencies: RateLimiter, Shared/Net

- Traits.server.lua
  • Type: ModuleScript
  • Purpose: Trait pool & attunement grants; supports first attunement granting permanent traits.
  • Dependencies: PlayerData

- Monolith.server.lua
  • Type: ModuleScript
  • Purpose: Monolith attunement handler; invokes Traits.RandomAttunement and applies small status when attuned.
  • Dependencies: Traits, Shared/Net

- Matchmaking.server.lua
  • Type: ModuleScript
  • Purpose: Simple party and invite handling scaffold (can be extended to instance creation).
  • Dependencies: Shared/Net

- Shop.server.lua
  • Type: ModuleScript
  • Purpose: Shop snapshots (RequestShop) and purchases (ShopBuy) with server-side gold checks and inventory changes.
  • Dependencies: Items, PlayerData

- Crafting.server.lua
  • Type: ModuleScript
  • Purpose: CraftItem remote validation, material checks, consume materials and add outputs.
  • Dependencies: Items, PlayerData

- Loot.server.lua
  • Type: ModuleScript
  • Purpose: Loot table rolling (Loot.RollFor), awarding gold/items, notifying clients via LootDropped event.
  • Dependencies: Items, PlayerData, Shared/Net

- AI.server.lua
  • Type: ModuleScript
  • Purpose: NPC spawning & server-side AI loops; pathfinding, aggro, and NPC attacks performed by calling Combat.ApplyDamage.
  • Dependencies: PathfindingService, Maid, Combat, Loot


StarterPlayer > StarterPlayerScripts > AstralFramework (LocalScript)
- Bootstrap.client.lua
  • Type: LocalScript
  • Purpose: Client bootstrapper. Requires controllers, invokes GetProfile, and initializes local controllers.
  • Dependencies: Shared/Net, Local controllers

- Controllers/Combat.client.lua
  • Type: LocalScript
  • Purpose: Input binding (mouse click -> LightAttack remote). Plays local VFX/animations. Sends minimal claimedDamage (server authoritative).
  • Dependencies: Shared/Net

- Controllers/Arcana.client.lua
  • Type: LocalScript
  • Purpose: Handles cast hotkeys (e.g., Q) -> CastAbility remote and listens for CastAbility client events to spawn local VFX/projectiles.
  • Dependencies: Shared/Net

- Controllers/Status.client.lua
  • Type: LocalScript
  • Purpose: Receives StatusApplied/StatusCleared events to update the HUD and effects.
  • Dependencies: Shared/Net

- Controllers/Shop.client.lua
  • Type: LocalScript
  • Purpose: Example client usage for shop: calls RequestShop and ShopBuy.
  • Dependencies: Shared/Net


Workspace (place in Explorer)
- NPCTemplates (Folder)
  • Type: Folder (no script)
  • Purpose: Store NPC models used as templates. Each model should include a Humanoid, HumanoidRootPart, Animator, and any Animation objects.

- NPCs (Folder - runtime)
  • Type: Folder (created at runtime)
  • Purpose: AI.Spawn clones templates into this folder. Do not place templates here.


Web / Local repo (for documentation and demo UI)
- client/pages/Index.tsx (React page)
  • Purpose: In-repo codex, Arcana catalog, shop/crafting demo UI, and the detailed Roblox framework notes.

- client/components/shop/ShopUI.tsx, CraftingUI.tsx, VendorNPC.tsx
  • Purpose: small web UIs for local testing and demoing shop/craft flows.

- client/data/codex.ts, client/data/items.ts
  • Purpose: local data used by the demo web UI.


==== End-to-End summary (what should be possible when wired) ====
- Player join: ServiceController boots services; PlayerData loads player profile from DataStore. Player has saved inventory, traits, and gold.
- Client initializes: Bootstrap requests GetProfile, shows HUD, binds input (left click, hotkeys) and local animation/VFX.
- Combat flow: Player targets an enemy and performs LightAttack or CastAbility. Client sends a minimal request; server validates distance and cooldowns then applies damage via Humanoid:TakeDamage. Server may also award gold/XP via PlayerData.
- NPC flow: Admin or spawning system clones NPC templates from NPCTemplates to NPCs. AI.server manages pathfinding and attacks (server-side), and Loot.RollFor awards drops when NPC dies.
- Monoliths: Player interacts (client or proximity) and Monolith.server triggers Traits.RandomAttunement granting permanent traits stored in PlayerData.
- Shop/Crafting: Client requests shop snapshot (RequestShop). ShopBuy and CraftItem are validated server-side and update PlayerData inventory/gold.
- Persistence: PlayerData autosaves periodically and when players leave with DataStore retry/backoff and schema migrations.


==== Assets & Animations (where to place & how to use) ====
- Store visual assets (ParticleEmitters, VFX models, weapon models) and Animation objects in ReplicatedStorage under folders like:
  ReplicatedStorage/Assets/Animations
  ReplicatedStorage/Assets/VFX
  ReplicatedStorage/Assets/Models

- NPC templates include Animation objects inside the model (or reference Animation IDs). Ensure Humanoid has an Animator to play animations.
- For players: keep Animation objects in ReplicatedStorage and the local controller or a character script should load and play them on the player's Humanoid.Animator.
- For projectiles: prefer server-controlled projectiles for authoritative collisions or use server validation after client-side visual projectile.


==== Practical tips for importing into Roblox Studio ====
1. Prefer using Rojo for a direct file->Explorer mapping. If not using Rojo, create the folder structure manually in Studio.
2. ModuleScripts: copy contents of Module .lua files into ModuleScript objects. Scripts: use regular Script under ServerScriptService. LocalScripts: place under StarterPlayerScripts.
3. After import, set appropriate script names exactly as in this manifest (ServiceController.server, Combat.server, etc.) to match code references.
4. Test iteratively: first start with ServiceController + PlayerData + Net + Config, then add Combat and AI, then Shop/Crafting/Loot.


If you want, I can also:
- Generate a Rojo project.json and ZIP with the exact folder layout for one-step import,
- Produce a sample NPC template (rbxm) and a minimal animation set for an attack cycle,
- Or export a Studio-compatible .rbxm that you can insert directly.

Tell me which of these you prefer next.
