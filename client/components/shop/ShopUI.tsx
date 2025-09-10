import { useEffect, useState } from "react";
import { Catalog } from "@/data/items";

export default function ShopUI() {
  const [balance, setBalance] = useState<number>(() => {
    const v = localStorage.getItem("htrea_gold");
    return v ? Number(v) : 500;
  });
  useEffect(() => {
    localStorage.setItem("htrea_gold", String(balance));
  }, [balance]);

  const buy = (id: string, price: number) => {
    if (balance < price) {
      alert("Not enough gold");
      return;
    }
    setBalance((b) => b - price);
    const inv = JSON.parse(localStorage.getItem("htrea_inv") || "{}");
    inv[id] = (inv[id] || 0) + 1;
    localStorage.setItem("htrea_inv", JSON.stringify(inv));
    alert("Purchased: " + id);
  };

  return (
    <div className="rounded-xl border border-white/10 bg-white/5 p-6">
      <div className="flex items-center justify-between">
        <h3 className="font-semibold text-lg">Vendor: Caravan Merchant</h3>
        <div className="text-sm">
          Gold: <strong>{balance}</strong>
        </div>
      </div>
      <div className="mt-4 grid sm:grid-cols-2 gap-4">
        {Catalog.map((c) => (
          <div
            key={c.id}
            className="p-3 rounded-md bg-white/3 border border-white/5"
          >
            <div className="flex items-center justify-between">
              <div>
                <div className="font-medium">{c.name}</div>
                <div className="text-xs text-slate-300">{c.description}</div>
              </div>
              <div className="text-right">
                <div className="font-semibold">{c.price} ⟆</div>
                <button
                  onClick={() => buy(c.id, c.price)}
                  className="mt-2 inline-flex items-center gap-2 rounded-md bg-primary text-primary-foreground px-3 py-1 text-sm font-semibold"
                >
                  Buy
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
