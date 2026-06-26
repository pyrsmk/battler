module Battler
  EAN_13 = 13
  EAN_8  = 8

  enum Race
    Mechanical    = 0
    Animal        = 1
    Aquatic       = 2
    Bard          = 3
    Human         = 4
    OneUseWeapon  = 5
    DurableWeapon = 6
    OneUseArmor   = 7
    DurableArmor  = 8
    Item          = 9
  end

  FIGHTERS = [Race::Mechanical, Race::Animal, Race::Aquatic, Race::Bard, Race::Human]
  WEAPONS  = [Race::OneUseWeapon, Race::DurableWeapon]
  ARMORS   = [Race::OneUseArmor, Race::DurableArmor]

  enum Job
    Soldier0  = 0
    Soldier1  = 1
    Soldier2  = 2
    Soldier3  = 3
    Soldier4  = 4
    Soldier5  = 5
    StSoldier = 6
    Wizard7   = 7
    Wizard8   = 8
    Wizard9   = 9
  end

  SOLDIER_JOBS = [Job::Soldier0, Job::Soldier1, Job::Soldier2,
                  Job::Soldier3, Job::Soldier4, Job::Soldier5]
  WIZARD_JOBS  = [Job::Wizard7, Job::Wizard8, Job::Wizard9]

  SPECIAL_DESCRIPTIONS = {
     1 => "3× ST damage vs Job 1 opponents",
     2 => "3× ST damage vs Job 2 opponents",
     3 => "3× ST damage vs Job 3 opponents",
     4 => "3× ST damage vs Job 4 opponents",
     5 => "3× ST damage vs Job 5 opponents",
     6 => "3× ST damage vs Job 6 opponents",
     7 => "3× ST damage vs Job 7 opponents",
     8 => "3× ST damage vs Job 8 opponents",
    10 => "3× ST damage vs Job 0 opponents",
    11 => "3× ST damage vs Race 1 opponents",
    12 => "3× ST damage vs Race 2 opponents",
    13 => "3× ST damage vs Race 3 opponents",
    14 => "3× ST damage vs Race 4 opponents",
    15 => "3× ST damage vs Race 0 opponents",
    16 => "Own ST -50%",
    17 => "Own ST +50%",
    21 => "Own DF +30%",
    23 => "Opponent ST -30%",
    25 => "Opponent DF -30%",
    27 => "Opponent DF -80%",
    28 => "Opponent HP -30% (before battle)",
    30 => "Cursed HP item: 50% chance to drain HP instead",
    31 => "Cursed ST weapon: 50% chance to penalize ST instead",
    32 => "Cursed DF armor: 50% chance to penalize DF instead",
    37 => "Own first-strike rate up",
    38 => "Own hit rate up",
    39 => "Opponent hit rate up",
    40 => "Own hit rate down",
    41 => "Opponent hit rate down",
    43 => "Opponent recovery rate down",
    44 => "Own recovery rate up",
    50 => "Hero card (Story Mode)",
    65 => "On defeat: hero gains +1000 HP",
    66 => "On defeat: hero gains +3000 HP",
    70 => "On defeat: hero gains +200 ST",
    71 => "On defeat: hero gains +400 ST",
    72 => "On defeat: hero gains +600 ST",
    73 => "On defeat: hero gains +800 ST",
    75 => "On defeat: hero gains +200 DF",
    76 => "On defeat: hero gains +400 DF",
    77 => "On defeat: hero gains +600 DF",
    78 => "On defeat: hero gains +800 DF",
  }
end
