import { useState } from "react";
import { Recipes, Catalog } from "@/data/items";

export default function CraftingUI() {
  const [materials, setMaterials] = useState<Record<string, number>>(() => {
    return JSON.parse(localStorage.getItem("htrea_inv") || "{}");
  });

  const craft = (recipeId: string) => {
    const r = Recipes.find((x) => x.id === recipeId);
    if (!r) return;
    // check materials
    for (const k of Object.keys(r.materials)) {
      if ((materials[k] || 0) < (r.materials as any)[k]) { alert("Missing materials"); return; }
    }
    const next = { ...materials };
    for (const k of Object.keys(r.materials)) next[k] -= (r.materials as any)[k];
    // add output
    next[r.id] = (next[r.id] || 0) + (r.outputQty || 1);
    setMaterials(next);
    localStorage.setItem("htrea_inv", JSON.stringify(next));
    alert("Crafted " + r.id);
  };

  return (
    <div className="rounded-xl border border-white/10 bg-white/5 p-6">
      <h3 className="font-semibold text-lg">Crafting Bench</h3>
      <div className="mt-4 grid sm:grid-cols-2 gap-4">
        {Recipes.map((r) => (
          <div key={r.id} className="p-3 rounded-md bg-white/3 border border-white/5">
            <div className="flex items-center justify-between">
              <div>
                <div className="font-medium">{Catalog.find(c=>c.id===r.id)?.name || r.id}</div>
                <div className="text-xs text-slate-300">Materials: {Object.entries(r.materials).map(([k,v])=>`${k} x${v}`).join(", ")}</div>
              </div>
              <div className="text-right">
                <button onClick={() => craft(r.id)} className="mt-2 inline-flex items-center gap-2 rounded-md bg-emerald-600 text-white px-3 py-1 text-sm font-semibold">Craft</button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
