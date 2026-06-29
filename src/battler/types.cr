module Battler
  enum Mode
    C0  = 0
    C1  = 1
    C2  = 2
  end

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

  enum CharacterType
    Enemy   = 1
    Soldier = 2
    Wizard  = 3
  end

  alias CharacterData = NamedTuple(
    barcode:  String,
    modes:    Array(Mode),
    type:     CharacterType,
    race:     Race,
    job:      Job,
    hp:       Int32,
    st:       Int32,
    df:       Int32,
    spd:      Int32,
    pp:       Int32,
    mp:       Int32,
    special:  Int32,
  )

  alias WeaponData = NamedTuple(
    barcode:  String,
    modes:    Array(Mode),
    race:     Race,
    st:       Int32,
    special:  Int32,
  )

  alias ArmorData = NamedTuple(
    barcode:  String,
    modes:    Array(Mode),
    race:     Race,
    df:       Int32,
    special:  Int32,
  )

  alias ItemData = NamedTuple(
    barcode:  String,
    modes:    Array(Mode),
    race:     Race,
    hp:       Int32,
    pp:       Int32,
    mp:       Int32,
    special:  Int32,
  )
end
