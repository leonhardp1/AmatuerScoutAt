<script>
  import { Search, Bell, Menu, Command } from 'lucide-svelte';
  
  let { onMenuClick } = $props();
</script>

<header class="sticky top-0 z-30 bg-background/80 backdrop-blur-xl border-b border-border">
  <div class="flex items-center justify-between px-4 lg:px-6 h-16">
    <!-- Left - Branding -->
    <div class="flex items-center gap-3">
      <button
        onclick={onMenuClick}
        class="lg:hidden p-2 hover:bg-muted rounded-lg transition-colors"
      >
        <Menu class="h-5 w-5 text-foreground" />
      </button>
      <div class="flex items-center gap-2">
        <div class="relative h-8 w-8 rounded-lg bg-gradient-to-br from-primary to-primary/60 flex items-center justify-center">
          <span class="text-primary-foreground font-bold text-sm">AS</span>
        </div>
        <div class="hidden sm:block">
          <h1 class="text-lg font-bold text-foreground leading-none">
            Amateur Scout
          </h1>
          <span class="text-xs text-accent font-medium">AT</span>
        </div>
      </div>
    </div>

    <!-- Center - Search Bar -->
    <div class="flex-1 max-w-xl mx-4 lg:mx-8">
      <div class="relative group">
        <Search class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
        <input
          type="text"
          placeholder="Search players, clubs, leagues..."
          class="w-full bg-input border border-border rounded-xl pl-10 pr-16 py-2.5 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary/50 focus:border-primary transition-all"
        />
        <div class="absolute right-3 top-1/2 -translate-y-1/2 hidden sm:flex items-center gap-1 text-xs text-muted-foreground bg-muted px-2 py-1 rounded-md">
          <Command class="h-3 w-3" />
          <span>K</span>
        </div>
      </div>
    </div>

    <!-- Right - Profile & Notifications -->
    <div class="flex items-center gap-2 lg:gap-4">
      <button class="relative p-2 hover:bg-muted rounded-lg transition-colors">
        <Bell class="h-5 w-5 text-muted-foreground" />
        <span class="absolute top-1.5 right-1.5 h-2 w-2 bg-primary rounded-full"></span>
      </button>
      
      <div class="flex items-center gap-3 pl-2 lg:pl-4 border-l border-border">
        <div class="hidden lg:block text-right">
          <p class="text-sm font-medium text-foreground leading-none">Max Mustermann</p>
          <p class="text-xs text-muted-foreground mt-0.5">Pro Scout</p>
        </div>
        <div class="relative h-9 w-9 rounded-full overflow-hidden ring-2 ring-primary/30 ring-offset-2 ring-offset-background">
          <img
            src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face"
            alt="Scout Profile"
            class="w-full h-full object-cover"
          />
        </div>
      </div>
    </div>
  </div>
</header>
