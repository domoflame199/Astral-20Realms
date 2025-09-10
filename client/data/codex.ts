export type Trait = { name: string; description: string };
export type Arcana = { name: string; theme: string; abilities: string[]; rareSub?: { name: string; theme: string; abilities: string[] } };

export const lore = {
  creation: [
    "Oving, the All-Father, formed the universe and the world of Htrea.",
    "He created four divine children: Aecron (Time), Solyra (Matter/Creation), Ordrin (Order), and Alastor (Antimatter/Corruption).",
    "Aecron forged the far-off elven realm of Elyndor; Solyra shaped Pangea, the starting continent; Ordrin raised the dwarven bastion of Khazdyr; Alastor, defiant, birthed the Underworld—twisted and wrong.",
    "Giants were Oving's firstborn, wielding Astral Spirits (incarnations of divine power).",
    "Mortals arose across Htrea; a giant named Fitz gifted them diluted Astral techniques that became 'Magic' and awakened innate 'Traits'.",
    "Alastor manipulated mortals and bred demonic giants, igniting the War of the Heavens. After ages, Oving stripped Alastor's power and cast him into the Underworld.",
    "Fitz persuaded the giants to spare humanity. Giants retreated to a hidden realm; their Monoliths remained as relics to measure and awaken mortal potential.",
    "In 649 AA (After Alastor), Underworld portals stir. Alastor hides his identity, feigning a benevolent god to tempt heroes, while Fitz aids the worthy—secretly—until the time to reveal himself.",
  ],
};

export const timeline = [
  { era: "Before Time", text: "Oving dreams the Astral Sea; sparks the Four." },
  { era: "Age of Shaping (−∞ to −5000)", text: "Aecron, Solyra, Ordrin, and Alastor craft the realms; Elyndor, Pangea, Khazdyr, and the Underworld take form." },
  { era: "Dawn of Titans (−5000 to −3000)", text: "Giants awaken; Monoliths erected; Astral Spirits bond with chosen titans." },
  { era: "First Mortals (−3000 to −1500)", text: "Humans, elves, dwarves and others appear across far continents and Pangea; early kingdoms rise." },
  { era: "Fitz's Gift (−1500)", text: "Fitz teaches mortals diluted Astral techniques; 'Magic' and innate 'Traits' emerge." },
  { era: "The War of the Heavens (−1500 to 0)", text: "Alastor corrupts mortals and breeds demonic giants; realms scarred by millennia of conflict." },
  { era: "0 AA", text: "Oving defeats Alastor, banishes him to the Underworld; the Astral Thrones are sealed." },
  { era: "1–300 AA", text: "The Withering Centuries; collateral storms and rifts; many giants vanish into a hidden realm." },
  { era: "301–420 AA", text: "Reclamation; mortals stabilize, monolith use spreads." },
  { era: "421–600 AA", text: "Rebuilding; trade among Pangea, Elyndor, and Khazdyr resumes; Underworld cults go to ground." },
  { era: "649 AA (Now)", text: "Rifts open; a reincarnated hero awakens. Fitz guides in disguise; Alastor tempts under an assumed godhood." },
];

export const world = {
  biomes: [
    { name: "Giants' Forest", text: "Mystic trees and ancient monoliths." },
    { name: "Scorched Desert", text: "Sandstorms and ruins." },
    { name: "Titan Peaks", text: "Jagged range and high-altitude shrines." },
    { name: "Golden Plains", text: "Expansive grasslands and caravan routes." },
  ],
  realms: [
    { name: "Elyndor", text: "Aecron/Time; elven halls across slow-time vales." },
    { name: "Khazdyr", text: "Ordrin/Order; dwarf citadels carved by law-bound geometry." },
    { name: "Underworld", text: "Alastor's malformed realm; portals bleed corruption into Htrea." },
    { name: "Hidden Giant Realm", text: "Rumored sanctuary accessible only by Astral rites." },
  ],
  races: [
    { name: "Humans", text: "Pangea and distant coasts." },
    { name: "Elves", text: "Chiefly in Elyndor." },
    { name: "Dwarves", text: "Khazdyr strongholds." },
    { name: "Demonic", text: "Lurk near rifts." },
  ],
};

export const traits: Trait[] = [
  { name: "Astral Knowledge", description: "Learn Astral abilities faster." },
  { name: "Stoneborn", description: "Increased defense and fortitude." },
  { name: "Flameheart", description: "Boosted fire affinity." },
  { name: "Aether Attuned", description: "Faster mana recovery." },
  { name: "Shadow Veil", description: "Stronger in darkness." },
  { name: "Beastbond", description: "Tame creatures easier." },
  { name: "Quickened Step", description: "Increased movement speed." },
  { name: "Giant's Echo", description: "Slightly stronger physical strikes." },
  { name: "Frostblood", description: "Resist cold damage." },
  { name: "Radiant Spirit", description: "Natural healing bonus." },
  { name: "Stormrunner", description: "Faster in storms." },
  { name: "Earthen Grip", description: "Stronger crowd control." },
  { name: "Dune Strider", description: "No movement penalty in deserts." },
  { name: "Tideborn", description: "Swim faster and hold breath longer." },
  { name: "Marksman's Eye", description: "Increased ranged accuracy." },
  { name: "Battle Instinct", description: "Chance to evade attacks." },
  { name: "Steel Will", description: "Resist fear and charm." },
  { name: "Arcane Affinity", description: "Reduced spell cost." },
  { name: "Nature's Blessing", description: "Bonus healing in forests." },
  { name: "Volcanic Soul", description: "Explosions deal more damage." },
  { name: "Wind Whisperer", description: "Slight lift during jumps." },
  { name: "Celestial Favor", description: "Small chance of divine boon." },
  { name: "Voidtouched", description: "Immune to minor curses." },
  { name: "Echoed Voice", description: "Shout abilities stronger." },
  { name: "Starforged", description: "Slight resistance to astral corruption." },
  { name: "Mystic Artisan", description: "Crafting efficiency boosted." },
  { name: "Soulbound", description: "Team synergy bonuses." },
  { name: "Ironblood", description: "Reduced bleeding damage." },
  { name: "Ghost Step", description: "Quieter movement." },
  { name: "Lucky Spark", description: "Increased critical chance." },
  { name: "Feral Rage", description: "Small damage boost at low HP." },
  { name: "Astral Vision", description: "Rarely reveal hidden entities." },
  { name: "Blessed Fortune", description: "Higher rare-drop chance." },
];

export const arcana: Arcana[] = [
  { name: "Fire", theme: "raw destructive flame", abilities: ["Ember Flick","Blazing Bolt","Flame Wave","Ignite","Inferno Step","Pyroclasm","Meteor Shower","Dragon's Breath"], rareSub: { name: "Magma", theme: "molten earthfire", abilities: ["Molten Hurl","Eruption","Lava Armor","Scorching Crust","Volcanic Spikes","Lava Flow","Infernal Rift","World's Maw"] } },
  { name: "Ice", theme: "freezing, control, defense", abilities: ["Frost Shard","Snowbind","Glacial Wall","Frozen Step","Icicle Volley","Blizzard Veil","Absolute Zero","Avalanche"], rareSub: { name: "Glacier", theme: "eternal crushing cold", abilities: ["Permafrost","Glacial Armor","Ice Spire","Snowstorm Prison","Frozen Prison","Whiteout","Avalanche Crush","Frozen Eternity"] } },
  { name: "Lightning", theme: "speed, stun, precision", abilities: ["Spark Touch","Shock Bolt","Chain Lightning","Thunderclap","Storm Dash","Static Field","Thunderstorm","Raijin's Wrath"], rareSub: { name: "Storm", theme: "divine thunderstorms", abilities: ["Storm Lash","Tempest Step","Storm Wall","Tempest Fury","Hurricane Strike","Cyclone of Thunder","Zeusbolt","World Tempest"] } },
  { name: "Earth", theme: "stability, stone, brute force", abilities: ["Pebble Toss","Earthen Armor","Tremor","Stone Pillar","Boulder Hurl","Roots of Htrea","Seismic Slam","Worldbreaker"], rareSub: { name: "Crystal", theme: "radiant refined minerals", abilities: ["Crystal Shard","Prism Barrier","Diamond Skin","Gem Burst","Lustre Beam","Stalactite Drop","Shard Storm","Prismatic Collapse"] } },
  { name: "Wind", theme: "mobility and battlefield control", abilities: ["Gust","Feather Step","Wind Slash","Cyclone Pull","Aerial Leap","Tempest Shield","Hurricane Spin","Skyfall Tempest"], rareSub: { name: "Tempest", theme: "ultimate storm winds", abilities: ["Howling Gale","Storm Carrier","Lightning Cyclone","Storm Barrier","Slicing Winds","Tempest Roar","Eye of the Storm","Heaven's Gale"] } },
  { name: "Water", theme: "flow, healing, tides", abilities: ["Water Jet","Healing Waters","Bubble Trap","Tidal Push","Whirlpool","Aqua Spear","Wave Crash","Leviathan's Call"], rareSub: { name: "Abyss", theme: "crushing deep ocean", abilities: ["Abyss Current","Drown","Tidal Prison","Tentacle Lash","Pressure Crush","Dark Whirlpool","Leviathan Rise","Abyssal Flood"] } },
  { name: "Light", theme: "healing, protection, illumination", abilities: ["Radiant Spark","Blessing of Dawn","Blinding Flash","Holy Ward","Smite","Beacon","Divine Chains","Judgment"], rareSub: { name: "Solar", theme: "sunfire and judgment", abilities: ["Sun Spark","Solar Flare","Sunray Beam","Halo Shield","Solar Spear","Dawnfire Burst","Crown of Flame","Eclipse Sunfall"] } },
  { name: "Shadow", theme: "stealth and decay", abilities: ["Umbral Flicker","Dark Bolt","Wither Touch","Shade Cloak","Soul Leech","Shadow Spike","Eclipse Field","Oblivion Rift"], rareSub: { name: "Conjuration", theme: "summoning void-born", abilities: ["Shade Minion","Umbral Claws","Conjure Wraith","Soul Puppeteer","Phantom Legion","Umbral Rift","Demon Pact","Endless Maw"] } },
];

export const legendary = [
  { name: "Time — Chronomancy (Aecron)", abilities: [
    "Chrono Step: rewind your position and health briefly.",
    "Temporal Lock: freeze a target in time for a short duration.",
    "Eternal Hourglass: slow the world while you move faster.",
  ]},
  { name: "Matter/Creation — Aetherforge (Solyra)", abilities: [
    "Astral Construct: conjure temporary weapon or shield.",
    "Genesis Wave: heal allies or restore terrain by reshaping.",
    "Worldmaker's Hand: instantly raise a large barrier or platform.",
  ]},
  { name: "Order — Celestial Decree (Ordrin)", abilities: [
    "Binding Chains: shackle foes under unbreakable law.",
    "Immutable Law: negate a chaotic effect in an area.",
    "Divine Judgement: smite those who break oaths nearby.",
  ]},
  { name: "Antimatter/Corruption — Abyssal Rift (Alastor)", abilities: [
    "Rift Tear: open a corrupting void crack dealing damage over time.",
    "Soul Rend: weaken a foe by tearing at their astral essence.",
    "Cataclysm Veil: corrupt a zone, randomizing status effects.",
  ]},
  { name: "Oving's Light — All-Father's Blessing", abilities: [
    "Hand of Oving: radiant strike that harms evil-aligned foes.",
    "Sacrifice of Light: convert your HP into a massive AoE heal.",
    "Divine Command: greatly boost allies' damage and resistance.",
  ]},
  { name: "Giant's Might — Astral Titan Arts", abilities: [
    "Astral Slam: quake shockwave imbued with titan spirit.",
    "Colossus Form: briefly grow in size and power.",
    "Starbound Throw: launch a foe skyward with astral force.",
  ]},
];

export const physicalAbilities = [
  "Power Slash", "Shield Bash", "Whirlwind", "Lunge", "Ground Slam", "Aerial Kick", "Berserker Rage", "Parry", "Dual Strike", "War Cry", "Arrow Volley", "Spear Thrust", "Backstab", "Counter Strike", "Dash Attack", "Hammer Crush", "Grapple Toss", "Shoulder Charge", "Feint Step", "Rising Cut"
];

export const skills = [
  "Invisibility","Berserk Mode","Double Jump","Wall Run","Blink","Camouflage","Battle Meditation","Sprint Burst","Iron Guard","Trap Disarm","Lockpick","Beast Call","Flame Weapon","Ice Armor","Thunder Step","Shadow Clone","Arcane Channel","Heal Touch","Life Steal","Astral Sense","Boulder Toss","Quick Reload","Throwing Mastery","Poison Blade","Smoke Bomb","Stunning Shout","Leap Slam","Energy Pulse","Wind Glide","Astral Anchor"
];

export const statusEffects = [
  "Burning","Frozen","Shocked","Bleeding","Poisoned","Stunned","Blinded","Silenced","Weakened","Exhausted","Cursed","Blessed","Hastened","Corrupted","Regenerating"
];

export const quickstart = [
  "Choose race → pick starter biome in Pangea.",
  "Find a Monolith to unlock 3 random traits (permanent).",
  "Train an elemental Arcana and a weapon style.",
  "Earn a Rare Sub-Arcana via trials (e.g., Solar from Light).",
  "Group for rift events and dungeons to craft Astral gear.",
  "Pursue Legendary Astral Arcana; confront Alastor's lieutenants.",
];

export const coreLoop = [
  "Explore → Attune → Train → Quest → Evolve → Group → Ascend → Confront.",
  "Biomes provide varied progression; far continents deliver endgame.",
  "Build diversity stems from traits + Arcana + race perks + skills.",
];

export const races = [
  { name: "Humans", perk: "Adaptive: gain experience faster; flexible builds." },
  { name: "Elves", perk: "Arcane Grace: larger mana pool and regen." },
  { name: "Dwarves", perk: "Stone Oath: higher defense and mining yield." },
  { name: "Giants (Hidden/Legacy)", perk: "Titan Blood: immense strength, astral synergy (unlock via endgame quest)." },
  { name: "Demonic (Alastor's)", perk: "Riftborne: immune to minor curses, weak to light (restricted or NPC foe)." },
];
