import { Link, NavLink } from "react-router-dom";

export default function Header() {
  return (
    <header className="sticky top-0 z-40 backdrop-blur supports-[backdrop-filter]:bg-background/70 bg-background/80 border-b">
      <div className="container mx-auto flex items-center justify-between py-3">
        <Link to="/" className="flex items-center gap-2">
          <span className="h-8 w-8 rounded bg-gradient-to-br from-violet-500 to-indigo-500 shadow ring-1 ring-white/20" />
          <span className="font-extrabold tracking-tight text-xl">
            Htrea: Astral Realms
          </span>
        </Link>
        <nav className="hidden md:flex items-center gap-6 text-sm">
          <NavLink
            to="/#lore"
            className={({ isActive }) =>
              isActive ? "text-primary" : "hover:text-primary"
            }
          >
            Lore
          </NavLink>
          <NavLink
            to="/#world"
            className={({ isActive }) =>
              isActive ? "text-primary" : "hover:text-primary"
            }
          >
            World
          </NavLink>
          <NavLink
            to="/#traits"
            className={({ isActive }) =>
              isActive ? "text-primary" : "hover:text-primary"
            }
          >
            Traits
          </NavLink>
          <NavLink
            to="/#arcana"
            className={({ isActive }) =>
              isActive ? "text-primary" : "hover:text-primary"
            }
          >
            Arcana
          </NavLink>
          <NavLink
            to="/#quickstart"
            className={({ isActive }) =>
              isActive ? "text-primary" : "hover:text-primary"
            }
          >
            Quickstart
          </NavLink>
          <a href="#framework" className="hover:text-primary">
            Roblox Framework
          </a>
        </nav>
        <a
          href="#framework"
          className="inline-flex items-center gap-2 rounded-md bg-primary text-primary-foreground px-4 py-2 text-sm font-semibold shadow hover:opacity-95 focus:outline-none focus:ring-2 focus:ring-ring"
        >
          Download Framework
        </a>
      </div>
    </header>
  );
}
