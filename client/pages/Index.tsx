import { useMemo, useState } from "react";
import {
  lore,
  timeline,
  world,
  traits,
  arcana,
  legendary,
  physicalAbilities,
  skills,
  statusEffects,
  quickstart,
  coreLoop,
  races,
} from "@/data/codex";

function SectionTitle({
  id,
  title,
  subtitle,
}: {
  id: string;
  title: string;
  subtitle?: string;
}) {
  return (
    <div id={id} className="scroll-mt-24">
      <h2 className="text-3xl md:text-4xl font-extrabold tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-violet-300 via-sky-300 to-emerald-300">
        {title}
      </h2>
      {subtitle && (
        <p className="text-muted-foreground mt-2 max-w-3xl">{subtitle}</p>
      )}
    </div>
  );
}

function Pill({ children }: { children: string }) {
  return (
    <span className="inline-flex items-center rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs md:text-sm text-slate-200">
      {children}
    </span>
  );
}

export default function Index() {
  const [traitQuery, setTraitQuery] = useState("");
  const filteredTraits = useMemo(
    () =>
      traits.filter((t) =>
        (t.name + " " + t.description)
          .toLowerCase()
          .includes(traitQuery.toLowerCase()),
      ),
    [traitQuery],
  );

  const arcanaColors: Record<string, string> = {
    Fire: "text-amber-300",
    Ice: "text-cyan-200",
    Lightning: "text-yellow-300",
    Earth: "text-emerald-300",
    Wind: "text-sky-200",
    Water: "text-teal-200",
    Light: "text-amber-100",
    Shadow: "text-violet-300",
  };

  const frameworkFiles = [
    "Shared/Signal.lua",
    "Shared/Net.lua",
    "Shared/Config.lua",
    "Server/ServiceController.server.lua",
    "Server/PlayerData.server.lua",
    "Server/Combat.server.lua",
    "Server/Monolith.server.lua",
    "Server/StatusEffects.server.lua",
    "Server/RateLimiter.server.lua",
    "Server/Matchmaking.server.lua",
    "Server/Arcana.server.lua",
    "Server/Traits.server.lua",
    "Client/Bootstrap.client.lua",
    "Client/Controllers/Combat.client.lua",
    "Client/Controllers/Arcana.client.lua",
    "Client/Controllers/Status.client.lua",
  ];

  const handleDownloadAll = async () => {
    for (const file of frameworkFiles) {
      const a = document.createElement("a");
      a.href = `/roblox-framework/${file}`;
      a.download = file.split("/").pop() || file;
      document.body.appendChild(a);
      a.click();
      a.remove();
      await new Promise((r) => setTimeout(r, 150));
    }
  };

  return (
    <div>
      {/* Hero */}
      <section className="relative overflow-hidden">
        <div className="absolute inset-0 pointer-events-none [background:radial-gradient(ellipse_at_top,rgba(99,102,241,.25),transparent_60%),radial-gradient(ellipse_at_bottom,rgba(56,189,248,.2),transparent_60%)]" />
        <div className="container mx-auto px-4 py-24 md:py-32">
          <div className="max-w-3xl">
            <div className="flex items-center gap-2 mb-6">
              <Pill>Multiplayer Roblox RPG Framework</Pill>
              <Pill>Optimized for Live Ops</Pill>
            </div>
            <h1 className="text-4xl md:text-6xl font-extrabold tracking-tight leading-tight">
              Htrea: Astral Realms
            </h1>
            <p className="mt-4 text-lg md:text-xl text-slate-300 max-w-2xl">
              A production-ready Roblox framework for a fantasy RPG inspired by
              the Astral Codex of Htrea. Includes synced combat, traits, arcana,
              status effects, data, and scalable services.
            </p>
            <div className="mt-8 flex flex-wrap gap-4">
              <a
                href="#framework"
                className="inline-flex items-center gap-2 rounded-md bg-primary text-primary-foreground px-6 py-3 text-base font-semibold shadow hover:opacity-95 focus:ring-2 focus:ring-ring"
              >
                Download Roblox Framework
              </a>
              <a
                href="#lore"
                className="inline-flex items-center gap-2 rounded-md border border-white/20 bg-transparent px-6 py-3 text-base font-semibold text-white/90 hover:bg-white/10"
              >
                Explore the Codex
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Codex Sections */}
      <section className="container mx-auto px-4 py-16 space-y-16">
        <div className="grid md:grid-cols-3 gap-8 items-start">
          <div className="md:col-span-2 space-y-6">
            <SectionTitle
              id="lore"
              title="Lore & Creation"
              subtitle="The origin tapestry of Oving, his divine children, and the rise of giants and mortals."
            />
            <ul className="space-y-3 text-slate-200">
              {lore.creation.map((line, i) => (
                <li key={i} className="flex gap-3">
                  <span className="mt-1 h-2 w-2 rounded-full bg-violet-400" />
                  <span>{line}</span>
                </li>
              ))}
            </ul>
          </div>
          <div className="rounded-xl border border-white/10 bg-white/5 p-6">
            <h3 className="font-bold text-lg mb-3">Player Quickstart</h3>
            <ol className="list-decimal list-inside space-y-2 text-slate-200">
              {quickstart.map((q, i) => (
                <li key={i}>{q}</li>
              ))}
            </ol>
            <div className="mt-4 text-sm text-slate-300">
              {coreLoop.map((c, i) => (
                <p key={i}>{c}</p>
              ))}
            </div>
          </div>
        </div>

        <div>
          <SectionTitle id="timeline" title="Timeline of Htrea" />
          <div className="mt-6 grid md:grid-cols-2 gap-6">
            {timeline.map((t, i) => (
              <div
                key={i}
                className="rounded-xl border border-white/10 bg-white/5 p-5"
              >
                <div className="text-violet-300 font-semibold">{t.era}</div>
                <div className="text-slate-200 mt-1">{t.text}</div>
              </div>
            ))}
          </div>
        </div>

        <div>
          <SectionTitle id="world" title="World of Htrea" />
          <div className="mt-6 grid md:grid-cols-3 gap-6">
            <div className="rounded-xl border border-white/10 bg-white/5 p-5">
              <h3 className="font-semibold">Pangea Biomes</h3>
              <ul className="mt-2 space-y-2">
                {world.biomes.map((b, i) => (
                  <li key={i}>
                    <span className="text-emerald-300 font-medium">
                      {b.name}
                    </span>{" "}
                    — {b.text}
                  </li>
                ))}
              </ul>
            </div>
            <div className="rounded-xl border border-white/10 bg-white/5 p-5">
              <h3 className="font-semibold">Far Realms</h3>
              <ul className="mt-2 space-y-2">
                {world.realms.map((r, i) => (
                  <li key={i}>
                    <span className="text-sky-300 font-medium">{r.name}</span> —{" "}
                    {r.text}
                  </li>
                ))}
              </ul>
            </div>
            <div className="rounded-xl border border-white/10 bg-white/5 p-5">
              <h3 className="font-semibold">Races & Racial Traits</h3>
              <ul className="mt-2 space-y-2">
                {races.map((r, i) => (
                  <li key={i}>
                    <span className="text-amber-300 font-medium">{r.name}</span>{" "}
                    — {r.perk}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>

        <div>
          <SectionTitle
            id="traits"
            title="Monoliths & Traits"
            subtitle="Attune to giant-built pillars to unlock three permanent, account-bound traits."
          />
          <div className="mt-4 flex flex-col md:flex-row md:items-center gap-3">
            <input
              value={traitQuery}
              onChange={(e) => setTraitQuery(e.target.value)}
              placeholder="Search traits..."
              className="w-full md:w-80 rounded-md bg-white/10 border border-white/10 px-3 py-2 outline-none focus:ring-2 focus:ring-violet-400"
            />
            <div className="text-sm text-slate-300">
              {filteredTraits.length} of {traits.length} shown
            </div>
          </div>
          <div className="mt-6 grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredTraits.map((t) => (
              <div
                key={t.name}
                className="rounded-lg border border-white/10 bg-white/5 p-4"
              >
                <div className="font-semibold text-slate-100">{t.name}</div>
                <div className="text-slate-300 text-sm mt-1">
                  {t.description}
                </div>
              </div>
            ))}
          </div>
        </div>

        <div>
          <SectionTitle
            id="arcana"
            title="Arcana Catalog"
            subtitle="Base elements with rare sub-arcana; master synergies for endgame builds."
          />
          <div className="mt-6 grid md:grid-cols-2 gap-6">
            {arcana.map((a) => (
              <div
                key={a.name}
                className="rounded-xl border border-white/10 bg-white/5 p-5 space-y-3"
              >
                <div className="flex items-baseline justify-between gap-4">
                  <div>
                    <div
                      className={`text-xl font-bold ${arcanaColors[a.name] || "text-white"}`}
                    >
                      {a.name} Arcana
                    </div>
                    <div className="text-sm text-slate-300">
                      Theme: {a.theme}
                    </div>
                  </div>
                  {a.rareSub && (
                    <div className="text-right">
                      <div className="text-sm font-semibold text-rose-200">
                        {a.rareSub.name} (Rare)
                      </div>
                      <div className="text-xs text-slate-300">
                        {a.rareSub.theme}
                      </div>
                    </div>
                  )}
                </div>
                <div className="grid sm:grid-cols-2 gap-2">
                  <div>
                    <div className="text-xs uppercase tracking-wide text-slate-400">
                      Abilities
                    </div>
                    <ul className="mt-1 space-y-1 text-slate-200 text-sm">
                      {a.abilities.map((ab) => (
                        <li key={ab}>• {ab}</li>
                      ))}
                    </ul>
                  </div>
                  {a.rareSub && (
                    <div>
                      <div className="text-xs uppercase tracking-wide text-slate-400">
                        {a.rareSub.name}
                      </div>
                      <ul className="mt-1 space-y-1 text-slate-200 text-sm">
                        {a.rareSub.abilities.map((ab) => (
                          <li key={ab}>• {ab}</li>
                        ))}
                      </ul>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>

        <div>
          <SectionTitle id="legendary" title="Legendary Astral Arcana" />
          <div className="mt-6 grid md:grid-cols-2 gap-6">
            {legendary.map((l) => (
              <div
                key={l.name}
                className="rounded-xl border border-white/10 bg-white/5 p-5"
              >
                <div className="font-semibold text-white">{l.name}</div>
                <ul className="mt-2 space-y-1 text-slate-200 text-sm">
                  {l.abilities.map((ab) => (
                    <li key={ab}>• {ab}</li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </div>

        <div>
          <SectionTitle id="abilities" title="Physical Abilities" />
          <div className="mt-4 flex flex-wrap gap-2">
            {physicalAbilities.map((a) => (
              <Pill key={a}>{a}</Pill>
            ))}
          </div>
        </div>

        <div>
          <SectionTitle id="skills" title="Skills (Learnable)" />
          <div className="mt-4 flex flex-wrap gap-2">
            {skills.map((s) => (
              <Pill key={s}>{s}</Pill>
            ))}
          </div>
        </div>

        <div>
          <SectionTitle id="status" title="Status Effects" />
          <div className="mt-6 grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {statusEffects.map((s) => (
              <div
                key={s}
                className="rounded-lg border border-white/10 bg-white/5 p-4"
              >
                <div className="font-semibold">{s}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Roblox Framework */}
        <div>
          <SectionTitle
            id="framework"
            title="Roblox Framework"
            subtitle="Modular, multiplayer-optimized framework for Htrea on Roblox. Includes services, networking, data, traits, arcana, combat, status, and client controllers."
          />
          <div className="mt-6 rounded-xl border border-white/10 bg-white/5 p-6 space-y-4">
            <div className="flex flex-wrap items-center gap-3">
              <button
                onClick={handleDownloadAll}
                className="inline-flex items-center gap-2 rounded-md bg-primary text-primary-foreground px-4 py-2 text-sm font-semibold shadow hover:opacity-95 focus:ring-2 focus:ring-ring"
              >
                Download All Files
              </button>
              <div className="text-sm text-slate-300">
                Files are organized to mirror Roblox services
                (ReplicatedStorage, ServerScriptService, StarterPlayerScripts).
              </div>
            </div>
            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <div className="text-xs uppercase tracking-wide text-slate-400">
                  ReplicatedStorage
                </div>
                <ul className="mt-2 space-y-2">
                  {frameworkFiles
                    .filter(
                      (f) =>
                        f.startsWith("Shared") ||
                        (f.startsWith("Client") == false &&
                          f.startsWith("Server") == false),
                    )
                    .map((f) => (
                      <li key={f}>
                        <a
                          className="text-sky-300 hover:underline"
                          href={`/roblox-framework/${f}`}
                          download
                        >
                          {f}
                        </a>
                      </li>
                    ))}
                  {frameworkFiles
                    .filter((f) => f.startsWith("Shared"))
                    .map((f) => (
                      <li key={f}>
                        <a
                          className="text-sky-300 hover:underline"
                          href={`/roblox-framework/${f}`}
                          download
                        >
                          {f}
                        </a>
                      </li>
                    ))}
                </ul>
              </div>
              <div>
                <div className="text-xs uppercase tracking-wide text-slate-400">
                  ServerScriptService + StarterPlayerScripts
                </div>
                <ul className="mt-2 space-y-2">
                  {frameworkFiles
                    .filter((f) => !f.startsWith("Shared"))
                    .map((f) => (
                      <li key={f}>
                        <a
                          className="text-emerald-300 hover:underline"
                          href={`/roblox-framework/${f}`}
                          download
                        >
                          {f}
                        </a>
                      </li>
                    ))}
                </ul>
              </div>
            </div>
            <div className="text-sm text-slate-300">
              Place Shared into ReplicatedStorage/AstralFramework, Server files
              under ServerScriptService/AstralFramework, and Client under
              StarterPlayer/StarterPlayerScripts/AstralFramework.
            </div>

            {/* Detailed framework notes (expanded) */}
            <div className="mt-6 rounded-lg border border-white/10 bg-white/4 p-5">
              <h4 className="text-lg font-semibold">
                Framework Notes — End-to-End
              </h4>
              <div className="mt-3 text-sm text-slate-200 space-y-3">
                <div>
                  <strong>Placement</strong>
                  <div>
                    ReplicatedStorage/AstralFramework/Shared (ModuleScripts);
                    ServerScriptService/AstralFramework (Scripts/ModuleScripts);
                    StarterPlayer/StarterPlayerScripts/AstralFramework
                    (LocalScripts).
                  </div>
                </div>

                <div>
                  <strong>Runtime behavior</strong>
                  <div>
                    Player joins → ServiceController starts services →
                    PlayerData loads profile → client Bootstrap requests profile
                    and initializes controllers. Combat/Arcana actions are
                    validated server-side and recorded to PlayerData (gold,
                    inventory, XP).
                  </div>
                </div>

                <div>
                  <strong>NPCs & AI</strong>
                  <div>
                    Import NPC Models to Workspace/NPCTemplates with a Humanoid
                    and HumanoidRootPart. AI.Spawn clones templates to
                    Workspace/NPCs and controls aggro, pathfinding, and
                    server-side attack application via Combat.ApplyDamage.
                  </div>
                </div>

                <div>
                  <strong>Assets & Animations</strong>
                  <div>
                    Store Animations, VFX, and equipment in ReplicatedStorage.
                    Attach Animation objects to Humanoids (Animator). Clients
                    play local animations & effects while server authoritatively
                    resolves outcomes (damage, loot).
                  </div>
                </div>

                <div>
                  <strong>Shops, Crafting & Loot</strong>
                  <div>
                    Use RequestShop / ShopBuy / CraftItem remotes.
                    Crafting.server validates materials, Loot.RollFor awards
                    items/gold, and PlayerData persists all changes. Shops
                    should be server-driven snapshots to prevent client
                    tampering.
                  </div>
                </div>

                <div>
                  <strong>Persistence</strong>
                  <div>
                    PlayerData implements autosave, DataStore retry/backoff, and
                    schema migrations. Profiles are copied to clients via
                    GetProfile (read-only snapshot) and all authoritative writes
                    happen server-side.
                  </div>
                </div>

                <div>
                  <strong>Tips</strong>
                  <ul className="list-disc ml-4 mt-1 text-slate-200">
                    <li>Keep authority on server for combat, loot, economy.</li>
                    <li>
                      Use Maid for per-player and per-NPC cleanup to avoid
                      leaks.
                    </li>
                    <li>
                      Place shared visual/sound assets in ReplicatedStorage for
                      safe cloning.
                    </li>
                    <li>
                      Use AnimationEvents and RemoteEvents to sync cast
                      starts/ends; implement client prediction with server
                      reconciliation for feel.
                    </li>
                  </ul>
                </div>

                <div>
                  <strong>Expected end-to-end flow</strong>
                  <div>
                    Players explore Pangea, encounter NPCs and rifts, use
                    Monoliths to attune and gain traits, learn Arcana via
                    training trials, group for dungeons (matchmaking), craft
                    gear, and ultimately pursue Legendary Astral Arcana to
                    confront Alastor. Server ensures persistence, anti-cheat
                    protection, and authoritative combat/loot.
                  </div>
                </div>

                <div>
                  <strong>Animations & Models</strong>
                  <div>
                    NPC Models: templates in Workspace/NPCTemplates with
                    humanoid, animator-ready animations and attributes
                    (AttackPower, LootTable). Player Animations: Animation
                    objects included in ReplicatedStorage and referenced from
                    character scripts or equipment. VFX/particles remain
                    client-side but are spawned via server notifications for
                    synchronized events.
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
