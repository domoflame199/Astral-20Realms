Roblox Framework: File mapping & placement

Overview: Place the Shared modules in ReplicatedStorage/AstralFramework/Shared, server modules/scripts in ServerScriptService/AstralFramework, and client LocalScripts inside StarterPlayer/StarterPlayerScripts/AstralFramework. NPC templates belong in Workspace/NPCTemplates and spawned NPCs will appear under Workspace/NPCs.

Shared (ModuleScript -> ReplicatedStorage/AstralFramework/Shared)
- Signal.lua — ModuleScript: lightweight signal helper for event callbacks
- Net.lua — ModuleScript: RemoteEvent/RemoteFunction registry (creates Events/Functions folders)
- Config.lua — ModuleScript: tuning constants (DataStore name, cooldowns, rates)
- Items.lua — ModuleScript: item catalog, recipes, loot tables
- Maid.lua — ModuleScript: resource/connection cleanup utility

Server (ModuleScript / Script -> ServerScriptService/AstralFramework)
- ServiceController.server.lua — Script: entry bootstrap (Run in ServerScriptService); requires modules and starts services
- RateLimiter.server.lua — ModuleScript: per-player token-bucket rate limiting
- PlayerData.server.lua — ModuleScript: DataStore persistence, autosave, schema validation & helper APIs (AddItem/AddGold/etc)
- StatusEffects.server.lua — ModuleScript: server-side status application & tick loop
- Combat.server.lua — ModuleScript: authoritative combat logic (ApplyDamage, validation, cooldowns)
- Arcana.server.lua — ModuleScript: ability handling, server-cast hooks
- Traits.server.lua — ModuleScript: trait pool, attunement grants
- Monolith.server.lua — ModuleScript: monolith attunement handler (calls Traits)
- Matchmaking.server.lua — ModuleScript: simple party/party-invite handler
- Shop.server.lua — ModuleScript: ShopBuy/RequestShop remote functions
- Crafting.server.lua — ModuleScript: CraftItem remote function and material checks
- Loot.server.lua — ModuleScript: roll loot tables, award gold/items (uses PlayerData)
- AI.server.lua — ModuleScript: NPC spawning, pathfinding loop; uses Maid to cleanup and calls Combat.ApplyDamage for NPC attacks

Client (LocalScript / Module -> StarterPlayer/StarterPlayerScripts/AstralFramework)
- Bootstrap.client.lua — LocalScript: client bootstrap; requires controllers and requests GetProfile
- Controllers/Combat.client.lua — LocalScript/Module: input handlers (left click -> LightAttack remote) and local effects
- Controllers/Arcana.client.lua — LocalScript/Module: cast hotkey Q -> CastAbility remote; listens to CastAbility client events
- Controllers/Status.client.lua — LocalScript/Module: listens and tracks applied/cleared statuses
- Controllers/Shop.client.lua — LocalScript/Module: simple example to request shop catalog & call ShopBuy

Workspace
- NPCTemplates (Folder) — place NPC template Models here (each with Humanoid + HumanoidRootPart)
- NPCs (Folder) — runtime spawns appear here (AI.Spawn places models here)

Web app (for developer docs / demo UI) — present in this repository
- client/pages/Index.tsx — In-app codex & Framework download UI
- client/components/shop/ShopUI.tsx, CraftingUI.tsx, VendorNPC.tsx — small web UIs for testing shop/craft flows locally
- client/data/codex.ts, client/data/items.ts — codex and items for UI demo

Notes & Best Practices
- Shared modules should be ModuleScripts under ReplicatedStorage so both client and server can require them (put only safe data in shared modules).
- Server modules (DataStore, combat, loot) must run under ServerScriptService; prefer ModuleScripts required by a central Script (ServiceController) to allow controlled Init/Start flows.
- Client controllers should be LocalScripts under StarterPlayerScripts to access Player/LocalPlayer APIs; keep heavy logic server-authoritative.
- Use Maid: attach connections per-player/ per-NPC (PlayerAdded/Spawn) and call Maid:Destroy() on cleanup to prevent leaks.
- Security: never trust client-provided damage values or state — always validate range, cooldowns, and clamp values server-side (Combat.server enforces this).

Quick deployment checklist
1. In Roblox Studio create Folder ReplicatedStorage/AstralFramework/Shared and put Signal/Net/Config/Items/Maid as ModuleScripts.
2. Create ServerScriptService/AstralFramework and add a Script ServiceController.server which requires server modules (RateLimiter, PlayerData, Combat, Arcana, Traits, Monolith, Shop, Crafting, Loot, AI, Matchmaking, StatusEffects) — the provided ServiceController does this.
3. Under StarterPlayer > StarterPlayerScripts create folder AstralFramework with Bootstrap.client.lua and Controllers folder.
4. Create Workspace/NPCTemplates and drop a sample NPC Model for testing; spawn via NPCSpawn remote or using ServiceController test hooks.
5. Test flows in Studio: players joining -> profile loaded (GetProfile), shop/craft via remotes, NPC spawn & AI behavior, combat using left click/Q.

If you want, I can also generate a single ZIP containing the exact ModuleScript/Script/LocalScript files organized for direct import into Roblox Studio. Tell me if you'd like that ZIP or any file refactored to ModuleScript vs Script differently.
