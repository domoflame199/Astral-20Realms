import { useState } from "react";

export default function DocsPanel() {
  const [open, setOpen] = useState(true);

  return (
    <aside
      className={`hidden md:flex flex-col fixed right-4 top-24 h-[70vh] w-80 z-50 transition-all duration-200 ${open ? "translate-x-0" : "translate-x-36"}`}
    >
      <div className="flex-1 rounded-xl border border-white/10 bg-white/6 p-4 overflow-auto shadow-lg">
        <div className="flex items-start justify-between gap-2">
          <div>
            <div className="text-sm font-semibold">Framework Notes & E2E</div>
            <div className="text-xs text-slate-300">
              Quick reference for Roblox import, assets, and expected flows.
            </div>
          </div>
          <button
            onClick={() => setOpen(!open)}
            className="text-xs px-2 py-1 rounded bg-white/5"
          >
            {open ? "Hide" : "Show"}
          </button>
        </div>

        <div className="mt-3 text-xs text-slate-200 space-y-2">
          <div>
            <strong>Placement:</strong>
            <div>
              ReplicatedStorage/AstralFramework/Shared (ModuleScripts),
              ServerScriptService/AstralFramework (Scripts/ModuleScripts),
              StarterPlayer/StarterPlayerScripts/AstralFramework (LocalScripts).
            </div>
          </div>

          <div>
            <strong>Runtime behavior:</strong>
            <div>
              Player joins → profile loaded → client controllers init. Client
              requests LightAttack/CastAbility; server validates, applies
              damage, status, loot, and saves via PlayerData.
            </div>
          </div>

          <div>
            <strong>NPCs & AI:</strong>
            <div>
              Import NPC Models into Workspace/NPCTemplates (Humanoid +
              HumanoidRootPart). AI.Spawn clones to Workspace/NPCs; server AI
              controls pathfinding and attacks via Combat.ApplyDamage.
            </div>
          </div>

          <div>
            <strong>Assets & Animations:</strong>
            <div>
              Store Animation objects and VFX in ReplicatedStorage. Attach
              Animations to Humanoid's Animator. Client plays local animations;
              server validates authority for effect outcomes.
            </div>
          </div>

          <div>
            <strong>Shops & Crafting:</strong>
            <div>
              Use RequestShop / ShopBuy / CraftItem remotes. PlayerData holds
              inventory and gold; server validates materials and persists
              results.
            </div>
          </div>

          <div>
            <strong>Persistence:</strong>
            <div>
              Autosave loop, DataStore retries, and schema migrations handled in
              PlayerData.server.lua.
            </div>
          </div>

          <div>
            <strong>Tips:</strong>
            <ul className="list-disc ml-4 mt-1">
              <li>
                Keep authoritative logic on the server (combat, loot, econ).
              </li>
              <li>Use Maid to cleanup per-player and per-NPC connections.</li>
              <li>
                Place visual/sound assets in ReplicatedStorage for safe cloning.
              </li>
            </ul>
          </div>
        </div>
      </div>
      <button onClick={() => setOpen(!open)} className="md:hidden">
        Toggle
      </button>
    </aside>
  );
}
