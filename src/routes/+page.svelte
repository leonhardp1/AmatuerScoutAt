<script>
  import { Users, TrendingUp, Star, MapPin } from 'lucide-svelte';
  import Header from '$lib/components/Header.svelte';
  import FilterSidebar from '$lib/components/FilterSidebar.svelte';
  import PlayerCard from '$lib/components/PlayerCard.svelte';
  
  let sidebarOpen = $state(false);
  
  const players = [
    {
      id: 1,
      name: 'Lukas Berger',
      position: 'Striker',
      age: 22,
      club: 'SK Rapid Wien II',
      clubLogo: 'https://images.unsplash.com/photo-1560272564-c83b66b1ad12?w=50&h=50&fit=crop',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
      goals: 18,
      matches: 24,
      rating: 8.2
    },
    {
      id: 2,
      name: 'Maximilian Huber',
      position: 'Central Midfielder',
      age: 20,
      club: 'Austria Salzburg',
      clubLogo: 'https://images.unsplash.com/photo-1614632537423-5e1f7b10dff9?w=50&h=50&fit=crop',
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop&crop=face',
      goals: 7,
      matches: 28,
      rating: 7.8
    },
    {
      id: 3,
      name: 'Sebastian Gruber',
      position: 'Center Back',
      age: 24,
      club: 'Sturm Graz II',
      clubLogo: 'https://images.unsplash.com/photo-1614632537423-5e1f7b10dff9?w=50&h=50&fit=crop',
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
      goals: 3,
      matches: 30,
      rating: 7.6
    },
    {
      id: 4,
      name: 'Felix Wagner',
      position: 'Winger',
      age: 19,
      club: 'LASK Juniors',
      clubLogo: 'https://images.unsplash.com/photo-1560272564-c83b66b1ad12?w=50&h=50&fit=crop',
      image: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&crop=face',
      goals: 12,
      matches: 22,
      rating: 8.0
    },
    {
      id: 5,
      name: 'Jonas Steiner',
      position: 'Goalkeeper',
      age: 23,
      club: 'Austria Lustenau',
      clubLogo: 'https://images.unsplash.com/photo-1614632537423-5e1f7b10dff9?w=50&h=50&fit=crop',
      image: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=200&h=200&fit=crop&crop=face',
      goals: 0,
      matches: 26,
      rating: 7.9
    },
    {
      id: 6,
      name: 'David Hofer',
      position: 'Defensive Midfielder',
      age: 21,
      club: 'FC Wacker Innsbruck',
      clubLogo: 'https://images.unsplash.com/photo-1560272564-c83b66b1ad12?w=50&h=50&fit=crop',
      image: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=200&h=200&fit=crop&crop=face',
      goals: 4,
      matches: 25,
      rating: 7.5
    },
    {
      id: 7,
      name: 'Michael Pichler',
      position: 'Full Back',
      age: 20,
      club: 'SV Ried',
      clubLogo: 'https://images.unsplash.com/photo-1614632537423-5e1f7b10dff9?w=50&h=50&fit=crop',
      image: 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=200&h=200&fit=crop&crop=face',
      goals: 2,
      matches: 27,
      rating: 7.7
    },
    {
      id: 8,
      name: 'Thomas Bauer',
      position: 'Attacking Midfielder',
      age: 22,
      club: 'Grazer AK',
      clubLogo: 'https://images.unsplash.com/photo-1560272564-c83b66b1ad12?w=50&h=50&fit=crop',
      image: 'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=200&h=200&fit=crop&crop=face',
      goals: 9,
      matches: 23,
      rating: 8.1
    }
  ];

  const stats = [
    { label: 'Total Players', value: '2,847', change: '+124', icon: Users, color: 'text-primary' },
    { label: 'Rising Talents', value: '156', change: '+12', icon: TrendingUp, color: 'text-accent' },
    { label: 'Top Rated', value: '89', change: '+7', icon: Star, color: 'text-primary' },
    { label: 'Regions Covered', value: '9', change: 'All', icon: MapPin, color: 'text-muted-foreground' }
  ];
</script>

<div class="min-h-screen bg-background">
  <div class="flex">
    <!-- Filter Sidebar -->
    <FilterSidebar isOpen={sidebarOpen} onClose={() => sidebarOpen = false} />

    <!-- Main Content -->
    <div class="flex-1 lg:ml-0">
      <Header onMenuClick={() => sidebarOpen = true} />

      <main class="p-4 lg:p-6">
        <!-- Stats Overview -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
          {#each stats as stat}
            <div class="bg-card backdrop-blur-xl border border-border rounded-xl p-4 hover:border-primary/30 transition-colors">
              <div class="flex items-center justify-between mb-2">
                <stat.icon class="h-5 w-5 {stat.color}" />
                <span class="text-xs text-primary font-medium bg-primary/10 px-2 py-0.5 rounded-full">
                  {stat.change}
                </span>
              </div>
              <p class="text-2xl font-bold text-foreground">{stat.value}</p>
              <p class="text-xs text-muted-foreground mt-1">{stat.label}</p>
            </div>
          {/each}
        </div>

        <!-- Section Header -->
        <div class="flex items-center justify-between mb-4">
          <div>
            <h2 class="text-xl font-bold text-foreground">Discover Talents</h2>
            <p class="text-sm text-muted-foreground">
              {players.length} players matching your criteria
            </p>
          </div>
          <div class="flex items-center gap-2">
            <select class="bg-input border border-border rounded-lg px-3 py-2 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-primary/50">
              <option>Sort by Rating</option>
              <option>Sort by Goals</option>
              <option>Sort by Age</option>
              <option>Sort by Matches</option>
            </select>
          </div>
        </div>

        <!-- Player Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          {#each players as player}
            <PlayerCard {player} />
          {/each}
        </div>

        <!-- Load More -->
        <div class="flex justify-center mt-8">
          <button class="bg-muted hover:bg-muted/80 text-foreground font-medium px-8 py-3 rounded-xl transition-colors border border-border hover:border-primary/30">
            Load More Players
          </button>
        </div>
      </main>
    </div>
  </div>
</div>
