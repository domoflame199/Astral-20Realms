In Roblox Studio, create Workspace -> NPCTemplates (Folder).

Add a Model for each NPC template. Example: Goblin
- Model Name: Goblin
- Add a Humanoid and a BasePart named HumanoidRootPart.
- Optionally set PrimaryPart to HumanoidRootPart.
- Set attributes on the Model (Right click -> Attributes):
  - AttackPower (number) e.g. 9
  - LootTable (string) e.g. "goblin"
  - XP (number) e.g. 25

Usage:
- Server remote Net.GetEvent("NPCSpawn") can spawn templates by name.
- AI.server will spawn and run basic AI (wander/chase/attack).
- On death, last player attacker (tagged by Combat.ApplyDamage) receives loot and XP.

Testing:
- Place a sample Goblin model in NPCTemplates and use the NPCSpawn remote or start the game to spawn via admin tools.
