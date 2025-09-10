import { useState } from "react";
import ShopUI from "./ShopUI";

export default function VendorNPC() {
  const [dialogOpen, setDialogOpen] = useState(false);
  const [activeTab, setActiveTab] = useState<"shop" | "quests">("shop");

  return (
    <div className="rounded-xl border border-white/10 bg-white/5 p-6">
      <div className="flex items-center justify-between">
        <div>
          <div className="font-semibold">Tavernkeeper Jorah</div>
          <div className="text-xs text-slate-300">
            A weathered vendor with a fondness for travelers.
          </div>
        </div>
        <button
          onClick={() => setDialogOpen((s) => !s)}
          className="rounded-md bg-primary text-primary-foreground px-3 py-1"
        >
          {dialogOpen ? "Close" : "Talk"}
        </button>
      </div>

      {dialogOpen && (
        <div className="mt-4">
          <div className="flex gap-2 mb-4">
            <button
              onClick={() => setActiveTab("shop")}
              className={`px-3 py-1 rounded ${activeTab === "shop" ? "bg-white/6" : "bg-transparent"}`}
            >
              Shop
            </button>
            <button
              onClick={() => setActiveTab("quests")}
              className={`px-3 py-1 rounded ${activeTab === "quests" ? "bg-white/6" : "bg-transparent"}`}
            >
              Quests
            </button>
          </div>
          {activeTab === "shop" ? (
            <ShopUI />
          ) : (
            <div className="rounded-md border border-white/5 p-4 bg-white/3">
              <h4 className="font-semibold">Available Quests</h4>
              <ul className="mt-2 text-sm text-slate-200 space-y-2">
                <li>
                  <strong>Rift Cleanup</strong> — Help seal a minor rift near
                  Golden Plains. Reward: 100 Gold.
                </li>
                <li>
                  <strong>Lost Caravan</strong> — Recover the merchant caravan's
                  lost supplies. Reward: Iron Sword schematic.
                </li>
              </ul>
              <div className="mt-3">
                <button className="rounded-md bg-amber-600 px-3 py-1 text-sm text-white">
                  Accept Quest
                </button>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
