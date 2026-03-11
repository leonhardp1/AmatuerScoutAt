<script>
  import { Target, Calendar, Trophy } from 'lucide-svelte';
  
  let { player } = $props();
</script>

<div class="group relative bg-card backdrop-blur-xl border border-border rounded-2xl p-5 transition-all duration-300 hover:scale-[1.02] hover:border-primary/50 hover:shadow-[0_0_30px_rgba(34,197,94,0.15)]">
  <!-- Glow effect on hover -->
  <div class="absolute inset-0 rounded-2xl bg-gradient-to-br from-primary/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
  
  <div class="relative z-10">
    <!-- Header - Player Image & Basic Info -->
    <div class="flex items-start gap-4 mb-4">
      <div class="relative">
        <div class="relative h-16 w-16 rounded-full overflow-hidden ring-2 ring-border group-hover:ring-primary/50 transition-all">
          <img
            src={player.image}
            alt={player.name}
            class="w-full h-full object-cover"
          />
        </div>
        <!-- Rating badge -->
        <div class="absolute -bottom-1 -right-1 h-6 w-6 bg-accent text-accent-foreground rounded-full flex items-center justify-center text-xs font-bold">
          {player.rating}
        </div>
      </div>
      
      <div class="flex-1 min-w-0">
        <h3 class="text-base font-bold text-foreground truncate group-hover:text-primary transition-colors">
          {player.name}
        </h3>
        <p class="text-sm text-muted-foreground">{player.position}</p>
        
        <!-- Club info -->
        <div class="flex items-center gap-2 mt-2">
          <div class="relative h-5 w-5 rounded-full overflow-hidden bg-muted">
            <img
              src={player.clubLogo}
              alt={player.club}
              class="w-full h-full object-cover"
            />
          </div>
          <span class="text-xs text-muted-foreground truncate">{player.club}</span>
        </div>
      </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-3 gap-3 mb-4">
      <div class="bg-muted/50 rounded-xl p-3 text-center">
        <Trophy class="h-4 w-4 text-primary mx-auto mb-1" />
        <p class="text-lg font-bold text-foreground">{player.goals}</p>
        <p class="text-xs text-muted-foreground">Goals</p>
      </div>
      <div class="bg-muted/50 rounded-xl p-3 text-center">
        <Target class="h-4 w-4 text-accent mx-auto mb-1" />
        <p class="text-lg font-bold text-foreground">{player.matches}</p>
        <p class="text-xs text-muted-foreground">Matches</p>
      </div>
      <div class="bg-muted/50 rounded-xl p-3 text-center">
        <Calendar class="h-4 w-4 text-muted-foreground mx-auto mb-1" />
        <p class="text-lg font-bold text-foreground">{player.age}</p>
        <p class="text-xs text-muted-foreground">Age</p>
      </div>
    </div>

    <!-- View Profile Button -->
    <button class="w-full bg-muted hover:bg-primary text-foreground hover:text-primary-foreground font-medium py-2.5 rounded-xl transition-all duration-300 group-hover:shadow-[0_0_20px_rgba(34,197,94,0.3)]">
      View Profile
    </button>
  </div>
</div>
