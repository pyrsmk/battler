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
    Warrior0  = 0
    Warrior1  = 1
    Warrior2  = 2
    Warrior3  = 3
    Warrior4  = 4
    Warrior5  = 5
    Warrior6  = 6
    Wizard7   = 7
    Wizard8   = 8
    Wizard9   = 9
  end

  WARRIOR_JOBS = [Job::Warrior0, Job::Warrior1, Job::Warrior2, Job::Warrior3, Job::Warrior4,
                  Job::Warrior5, Job::Warrior6]
  WIZARD_JOBS  = [Job::Wizard7, Job::Wizard8, Job::Wizard9]

  enum CharacterType
    Enemy   = 1
    Warrior = 2
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
