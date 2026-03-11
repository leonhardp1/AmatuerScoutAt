<script>
  import { ChevronDown, MapPin, User, Target, X } from 'lucide-svelte';
  
  let { isOpen, onClose } = $props();
  
  // Filter states
  let bundesland = $state('');
  let liga = $state('');
  let position = $state('');
  let ageRange = $state([16, 35]);
  let goalsRange = $state([0, 50]);
  let matchesRange = $state([0, 40]);
  
  // Section open states
  let locationOpen = $state(true);
  let profileOpen = $state(true);
  let performanceOpen = $state(true);
  
  const bundeslaender = [
    'Wien', 'Niederoesterreich', 'Oberoesterreich', 'Steiermark',
    'Tirol', 'Kaernten', 'Salzburg', 'Vorarlberg', 'Burgenland'
  ];
  
  const ligen = [
    'Landesliga', 'Regionalliga', '2. Landesliga',
    'Gebietsliga', 'Bezirksliga', '1. Klasse', '2. Klasse'
  ];
  
  const positions = [
    'Goalkeeper', 'Center Back', 'Full Back', 'Defensive Midfielder',
    'Central Midfielder', 'Attacking Midfielder', 'Winger', 'Striker'
  ];
</script>

<!-- Mobile overlay -->
{#if isOpen}
  <button
    class="fixed inset-0 bg-black/60 backdrop-blur-sm z-40 lg:hidden"
    onclick={onClose}
    aria-label="Close sidebar"
  ></button>
{/if}

<!-- Sidebar -->
<aside
  class="fixed top-0 left-0 z-50 h-full w-80 bg-sidebar/95 backdrop-blur-xl border-r border-sidebar-border transition-transform duration-300 lg:translate-x-0 lg:static lg:z-auto {isOpen ? 'translate-x-0' : '-translate-x-full'}"
>
  <div class="flex items-center justify-between p-4 border-b border-sidebar-border">
    <h2 class="text-lg font-semibold text-foreground flex items-center gap-2">
      <Target class="h-5 w-5 text-primary" />
      Filters
    </h2>
    <button
      onclick={onClose}
      class="lg:hidden p-1 hover:bg-muted rounded-md transition-colors"
    >
      <X class="h-5 w-5 text-muted-foreground" />
    </button>
  </div>

  <div class="overflow-y-auto h-[calc(100%-65px)]">
    <!-- Location Section -->
    <div class="border-b border-border/50">
      <button
        onclick={() => locationOpen = !locationOpen}
        class="flex w-full items-center justify-between px-4 py-3 text-sm font-medium text-foreground hover:bg-muted/50 transition-colors"
      >
        <div class="flex items-center gap-2">
          <MapPin class="h-4 w-4 text-primary" />
          <span>Location</span>
        </div>
        <ChevronDown class="h-4 w-4 text-muted-foreground transition-transform duration-200 {locationOpen ? 'rotate-180' : ''}" />
      </button>
      {#if locationOpen}
        <div class="px-4 pb-4 space-y-4">
          <div class="space-y-2">
            <label class="text-xs text-muted-foreground">Bundesland</label>
            <select
              bind:value={bundesland}
              class="w-full bg-input border border-border rounded-lg px-3 py-2 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-primary/50 appearance-none cursor-pointer"
            >
              <option value="">All Bundesland</option>
              {#each bundeslaender as bl}
                <option value={bl}>{bl}</option>
              {/each}
            </select>
          </div>
          <div class="space-y-2">
            <label class="text-xs text-muted-foreground">Liga</label>
            <select
              bind:value={liga}
              class="w-full bg-input border border-border rounded-lg px-3 py-2 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-primary/50 appearance-none cursor-pointer"
            >
              <option value="">All Liga</option>
              {#each ligen as l}
                <option value={l}>{l}</option>
              {/each}
            </select>
          </div>
        </div>
      {/if}
    </div>

    <!-- Player Profile Section -->
    <div class="border-b border-border/50">
      <button
        onclick={() => profileOpen = !profileOpen}
        class="flex w-full items-center justify-between px-4 py-3 text-sm font-medium text-foreground hover:bg-muted/50 transition-colors"
      >
        <div class="flex items-center gap-2">
          <User class="h-4 w-4 text-accent" />
          <span>Player Profile</span>
        </div>
        <ChevronDown class="h-4 w-4 text-muted-foreground transition-transform duration-200 {profileOpen ? 'rotate-180' : ''}" />
      </button>
      {#if profileOpen}
        <div class="px-4 pb-4 space-y-4">
          <div class="space-y-2">
            <label class="text-xs text-muted-foreground">Position</label>
            <select
              bind:value={position}
              class="w-full bg-input border border-border rounded-lg px-3 py-2 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-primary/50 appearance-none cursor-pointer"
            >
              <option value="">All Position</option>
              {#each positions as pos}
                <option value={pos}>{pos}</option>
              {/each}
            </select>
          </div>
          <div class="space-y-2">
            <div class="flex items-center justify-between text-xs">
              <span class="text-muted-foreground">Age</span>
              <span class="text-foreground font-medium">{ageRange[0]} - {ageRange[1]}</span>
            </div>
            <div class="relative h-2 bg-muted rounded-full">
              <div
                class="absolute h-full bg-gradient-to-r from-primary to-primary/70 rounded-full"
                style="left: {((ageRange[0] - 16) / (40 - 16)) * 100}%; right: {100 - ((ageRange[1] - 16) / (40 - 16)) * 100}%;"
              ></div>
            </div>
            <div class="flex gap-2">
              <input type="range" min="16" max="40" bind:value={ageRange[0]} class="w-full opacity-50" />
              <input type="range" min="16" max="40" bind:value={ageRange[1]} class="w-full opacity-50" />
            </div>
          </div>
        </div>
      {/if}
    </div>

    <!-- Performance Section -->
    <div class="border-b border-border/50">
      <button
        onclick={() => performanceOpen = !performanceOpen}
        class="flex w-full items-center justify-between px-4 py-3 text-sm font-medium text-foreground hover:bg-muted/50 transition-colors"
      >
        <div class="flex items-center gap-2">
          <Target class="h-4 w-4 text-primary" />
          <span>Performance</span>
        </div>
        <ChevronDown class="h-4 w-4 text-muted-foreground transition-transform duration-200 {performanceOpen ? 'rotate-180' : ''}" />
      </button>
      {#if performanceOpen}
        <div class="px-4 pb-4 space-y-4">
          <div class="space-y-2">
            <div class="flex items-center justify-between text-xs">
              <span class="text-muted-foreground">Goals (Season)</span>
              <span class="text-foreground font-medium">{goalsRange[0]} - {goalsRange[1]}</span>
            </div>
            <div class="relative h-2 bg-muted rounded-full">
              <div
                class="absolute h-full bg-gradient-to-r from-primary to-primary/70 rounded-full"
                style="left: {(goalsRange[0] / 50) * 100}%; right: {100 - (goalsRange[1] / 50) * 100}%;"
              ></div>
            </div>
            <div class="flex gap-2">
              <input type="range" min="0" max="50" bind:value={goalsRange[0]} class="w-full opacity-50" />
              <input type="range" min="0" max="50" bind:value={goalsRange[1]} class="w-full opacity-50" />
            </div>
          </div>
          <div class="space-y-2">
            <div class="flex items-center justify-between text-xs">
              <span class="text-muted-foreground">Matches</span>
              <span class="text-foreground font-medium">{matchesRange[0]} - {matchesRange[1]}</span>
            </div>
            <div class="relative h-2 bg-muted rounded-full">
              <div
                class="absolute h-full bg-gradient-to-r from-primary to-primary/70 rounded-full"
                style="left: {(matchesRange[0] / 40) * 100}%; right: {100 - (matchesRange[1] / 40) * 100}%;"
              ></div>
            </div>
            <div class="flex gap-2">
              <input type="range" min="0" max="40" bind:value={matchesRange[0]} class="w-full opacity-50" />
              <input type="range" min="0" max="40" bind:value={matchesRange[1]} class="w-full opacity-50" />
            </div>
          </div>
        </div>
      {/if}
    </div>

    <!-- Apply Buttons -->
    <div class="p-4">
      <button class="w-full bg-primary text-primary-foreground font-medium py-2.5 rounded-lg hover:bg-primary/90 transition-colors">
        Apply Filters
      </button>
      <button class="w-full text-muted-foreground text-sm mt-2 py-2 hover:text-foreground transition-colors">
        Reset All
      </button>
    </div>
  </div>
</aside>
