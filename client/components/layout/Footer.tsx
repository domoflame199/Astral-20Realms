export default function Footer() {
  return (
    <footer className="border-t">
      <div className="container mx-auto py-8 text-sm text-muted-foreground flex flex-col md:flex-row items-center justify-between gap-4">
        <p>© {new Date().getFullYear()} Htrea: Astral Realms. All rights reserved.</p>
        <div className="flex items-center gap-6">
          <a href="#lore" className="hover:text-foreground">Lore</a>
          <a href="#arcana" className="hover:text-foreground">Arcana</a>
          <a href="#framework" className="hover:text-foreground">Framework</a>
        </div>
      </div>
    </footer>
  );
}
