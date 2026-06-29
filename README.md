# Battler

Display barcode informations as seen by the Barcode Battler II handheld game system.

## Usage

```
battler <ean_digits>
```

The tool accepts any valid EAN-8 or EAN-13 barcode (digits only, checksum validated) and displays the full card stats for both VS Mode and Story Mode.

## Console Versions

The Barcode Battler line went through three hardware generations, each expanding the gameplay system. This project targets the **Barcode Battler II**.

### Barcode Battler (1991)

![Barcode Battler original](https://strategygamesevolution.com/wp-content/uploads/2023/03/bb_ref_bb1.jpg)

- **Color:** White
- **Scanner:** Integrated barcode reader (JAN/EAN/UPC/ISBN)
- **Classes:** Warriors only (no magic system)
- **Stats:** HP, ST, DF + hidden special ability
- **Modes:**
  - COM: Single-player against 10 internal stages (60 enemies)
  - B1: Story progression with card software
  - B2: Free versus battles
- **Items:** Unlimited healing capacity

### Barcode Battler II (1992) — *the version supported by this project*

![Barcode Battler II](https://images.timeextension.com/7a328169720fb/large.jpg)

- **Color:** Black with purple buttons
- **Scanner:** Integrated barcode reader + output port for Famicom / Super Famicom
- **Classes:** 2 — Warrior (job 0-6) and Wizard (job 7-9)
- **Magic:** 10 spells, Wizards get 10 MP
- **Items:** Herb recovery limited to 5 base, 3 max simultaneous
- **Modes:**
  - C0: Versus battles (unrestricted fusion)
  - C1: Story mode (4 stages + 2 hidden)
  - C2: Card-based campaign (enemies scanned from physical decks)
- **Console connectivity:** Interface unit for Famicom/Super Famicom (Barcode World, Conveni Wars)
- **Card software:** Licensed franchises (Super Mario World, Zelda, Dragon Slayer...)

### Barcode Battler II2 "Double" (1993)

![Barcode Battler II2 Double](https://stat.ameba.jp/user_images/3d/56/10136644388.jpg)

An expansion of the BB II, sold as **two separate devices** (due to storage limitations):

- **C0 model** ("Ko-Battler"): Multiplayer-oriented (up to 4 players, tag-team 2v2, battle royale)
- **C2 model**: Single-player / story-oriented

Key differences from the BB II:

| | BB II | BB II2 Double |
|---|---|---|
| Classes | 2 (Warrior, Wizard) | 4 (Warrior, Wizard, Monk, Saint Soldier) |
| HP max | 99,900 | 199,900 |
| ST max | 19,900 | 99,900 |
| DF max | 19,900 | 99,900 |
| Spells | 10 | 15 |
| Equipment slots | 1 | 2 |

Class distribution by job digit:

| Digit | BB II | BB II2 Double |
|---|---|---|
| 0, 1, 2, 3, 5 | Warrior | Warrior |
| 4 | Warrior | Monk (new) |
| 6 | Warrior | Saint Soldier (new) |
| 7, 8, 9 | Wizard | Wizard |

The Monk can use recovery magic. The Saint Soldier is a rare hybrid class that can use both weapons and magic. Both new classes have a 1-in-10 rarity (distribution ratio 5:3:1:1).

**Notable hardware limitation:** the Double has **no barcode scanner** of its own. It requires a BB II unit to scan barcodes and transfer data via cable, effectively requiring two devices to play.

![Barcode Battler II2 Double (rear/cable view)](https://stat.ameba.jp/user_images/12/79/10136644584.jpg)

## Barcode Battler II Technical Reference

Barcode Battler II (1992, Epoch) is a handheld game that reads standard EAN barcodes from everyday product packaging and converts them into battle cards. Every barcode produces a unique card with its own stats, type, and special ability — making any barcode scanner a card generator.

### Barcode Formats

The device accepts two standard barcode formats:

| Format | Digits | Notes |
|--------|--------|-------|
| EAN-13 | 13     | Most product barcodes; full stat range |
| EAN-8  | 8      | Compact product barcodes; always uses post-reading |

The last digit is the EAN check digit, calculated from the preceding digits. It also carries meaning in post-reading mode (see below).

### Reading Modes

A barcode is decoded using one of two methods. The device selects the method automatically based on specific digit positions.

#### Pre-reading (Direct Mapping)

Stats are read directly from the barcode digits with no transformation. This method applies when:

- The first digit is `0` or `1`, and the race digit (position 7) encodes a fighter race (`0`–`4`)
- The first digit is `0` or `1`, the race digit encodes a non-fighter, and the raw stat values are low (HP ≤ 50, ST ≤ 19, DF ≤ 19)
- The first digit is `2`–`9`, digit at position 2 is `9`, and digit at position 9 is `5`

Digit layout in pre-reading:

```
Position:  0-1-2  3-4  5-6  7   8   9    10-11  12
           [ HP ] [ST] [DF] [R] [J] [Sp] [Spec] [CK]

HP       : digits 0–2
ST       : digits 3–4
DF       : digits 5–6
Race     : digit 7
Job      : digit 8
Speed    : digit 9
Special  : digits 10–11
Checksum : digit 12
```

#### Post-reading (Formula-Based)

When the barcode does not qualify for pre-reading, stats are derived through a non-linear formula applied to the upper digits. The race is determined by the last digit (position 12 — the EAN check digit). Stats involve modular arithmetic and digit recombination:

- **HP** — derived from digits 9, 10, 11 (digit 11 halved, then concatenated)
- **ST** — derived from digits 9 and 10 with +7/+5 offsets and modulo-10 wrapping
- **DF** — derived from digits 8 and 9 with +7 offsets and modulo-10 wrapping
- **Job** — digit 5 (EAN-13 only)
- **Speed** — digit 10
- **Special** — derived from digits 8 and 10 depending on the value of digit 8

Weapon and armor bonuses also follow distinct formulas in this mode.

### Stats

All raw stat values are multiplied by 100 to get the in-game value (e.g., a raw HP of 420 becomes 42,000 in-game).

| Stat  | Description |
|-------|-------------|
| **HP** | Hit Points — the card's life total |
| **ST** | Strength — offensive power |
| **DF** | Defense — damage reduction |
| **Speed** | Determines turn order in battle |
| **PP** | Power Points — herb/recovery charges; fighters always start with 5 |
| **MP** | Magic Points — available only to Wizards (Job ≥ 7); starts at 10 |

### Card Types

The race digit determines the card's role in battle.

#### Fighters

Fighters are the primary battle cards. There are five races:

| Race       | Value | Notes |
|------------|-------|-------|
| Mechanical | 0     | Strong attack bias; HP ≥ 200 grants +ST bonus |
| Animal     | 1     | Strong defense bias; HP ≥ 200 grants +DF bonus |
| Aquatic    | 2     | Balanced; HP ≥ 200 grants both +ST and +DF |
| Bard       | 3     | No race-specific bonus |
| Human      | 4     | No race-specific bonus |

##### Race Bonuses (Pre-reading, HP ≥ 200)

These bonuses are applied automatically when a fighter's raw HP reaches 200 or more:

| Race       | Condition | Bonus |
|------------|-----------|-------|
| Mechanical | Always    | ST +100 |
| Mechanical | ST digits ∈ {13, 29, 45, 61, 77, 93} | ST +100, DF +100 (additional) |
| Animal     | Always    | DF +100 |
| Animal     | DF digits ∈ {13, 29, 45, 61, 77, 93} | ST +100, DF +100 (additional) |
| Aquatic    | Always    | ST +100, DF +100 |

#### Weapons

Weapons provide an ST bonus to a fighter when played before a battle.

| Race         | Value | Durability |
|--------------|-------|------------|
| One-Use Weapon  | 5  | Consumed after one battle |
| Durable Weapon  | 6  | Persists across battles |

#### Armors

Armors provide a DF bonus to a fighter when played before a battle.

| Race        | Value | Durability |
|-------------|-------|------------|
| One-Use Armor  | 7  | Consumed after one battle |
| Durable Armor  | 8  | Persists across battles |

#### Items (Power cards)

Items restore stats and are identified by their Job digit:

| Job value | Effect |
|-----------|--------|
| 0–4       | Restores HP |
| 5–6       | Info card (Story Mode / C1 only) |
| 7         | Restores PP |
| 8–9       | Restores MP |

### Jobs

Jobs apply to fighters and determine their class. Warriors and Wizards have different capabilities in battle.

| Job       | Value | Class   | Notes |
|-----------|-------|---------|-------|
| Warrior 0 | 0     | Warrior | — |
| Warrior 1 | 1     | Warrior | — |
| Warrior 2 | 2     | Warrior | — |
| Warrior 3 | 3     | Warrior | — |
| Warrior 4 | 4     | Warrior | — |
| Warrior 5 | 5     | Warrior | — |
| Warrior 6 | 6     | Warrior | — |
| Wizard 7  | 7     | Wizard  | Magic user; starts with 10 MP |
| Wizard 8  | 8     | Wizard  | Magic user; starts with 10 MP |
| Wizard 9  | 9     | Wizard  | Magic user; starts with 10 MP |

Warriors cannot use magic (MP = 0). Wizards have access to MP-based abilities.

### Game Modes

#### C0 Mode (VS, 2-player)

Full stats are used as-is. This is the standard competitive mode where two players face off with their scanned cards.

#### C1 Mode (Story, single-player)

In single-player story mode, the player scans a warrior and a wizard as heroes. The 120 enemies are built into the console's ROM (4 epochs × 6 levels × 5 stages). Fighter stats are scaled down using the following formula:

```
HP  = (HP  ÷ 10)
ST  = (ST  ÷ 10) + 1
DF  = (DF  ÷ 10) + 3
```

These values are then multiplied by 100 for the in-game display. For example, a VS Mode card with HP 42,000 / ST 9,500 / DF 7,800 becomes HP 4,200 / ST 1,000 / DF 1,000 in Story Mode.

#### C2 Mode (Card-based campaign)

In C2 mode, enemies are scanned from physical card decks rather than drawn from ROM. The player scans hero cards, then manually scans enemy cards to fight them one by one.

##### Enemy Card Detection

Official enemy cards (from the Conveni Wars base set) are identified by a specific barcode pattern. For EAN-13 barcodes where the first digit is `2`–`9`:

- Digit at position 2 must be `9`
- Digit at position 9 must be `5`

This pattern also happens to be the pre-reading condition for barcodes starting with `2`–`9`. As a consequence, all enemy cards have a fixed Speed of 5 (since digit 9 encodes Speed in pre-reading mode).

The console uses this pattern to reject enemy cards when a player attempts to scan them as heroes in C1 mode.

### Special Effects

Each card carries one special effect encoded in the barcode. In pre-reading mode it comes from digits 10–11; in post-reading mode it is derived from digits 8 and 10. A value of `0` means no special effect.

The original Barcode Battler manual deliberately left most of these effects undocumented, encouraging players to discover them through trial and error. The descriptions below come from the original Japanese source material and community reverse-engineering. Effects marked *uncertain* have no confirmed mechanical specification beyond their Japanese label.

#### Conditional 3× Attack (「三倍剣」— "Triple Sword")

**Codes 1–8, 10 (job-targeting) and 11–15 (race-targeting)**

The Japanese term 三倍剣 (*sanbai ken*, "triple sword") refers to a conditional attack multiplier. When this card's ST attack lands against an opponent whose **Job** (codes 1–8, 10) or **Race** (codes 11–15) matches the encoded target, the attack deals **3× the card's ST value** instead of the normal amount.

This is the most common special effect in the game. It is highly situational — it does nothing against mismatched opponents — but dominant when the condition is met.

| Code | Trigger condition |
|------|-------------------|
| 1    | Opponent is Job 1 (Warrior 1) |
| 2    | Opponent is Job 2 (Warrior 2) |
| 3    | Opponent is Job 3 (Warrior 3) |
| 4    | Opponent is Job 4 (Warrior 4) |
| 5    | Opponent is Job 5 (Warrior 5) |
| 6    | Opponent is Job 6 (Warrior 6) |
| 7    | Opponent is Job 7 (Wizard 7) |
| 8    | Opponent is Job 8 (Wizard 8) |
| 10   | Opponent is Job 0 (Warrior 0) |
| 11   | Opponent is Race 1 (Animal) |
| 12   | Opponent is Race 2 (Aquatic) |
| 13   | Opponent is Race 3 (Bard) |
| 14   | Opponent is Race 4 (Human) |
| 15   | Opponent is Race 0 (Mechanical) |

#### Stat Multipliers

These effects modify the card's own stats or the opponent's stats for the duration of the battle.

| Code | Effect | Direction |
|------|--------|-----------|
| 16   | Own ST ×0.5 (−50%) | Self debuff |
| 17   | Own ST ×1.5 (+50%) | Self buff |
| 21   | Own DF ×1.3 (+30%) | Self buff |
| 23   | Opponent ST ×0.7 (−30%) | Opponent debuff |
| 25   | Opponent DF ×0.7 (−30%) | Opponent debuff |
| 27   | Opponent DF ×0.2 (−80%) | Opponent debuff |
| 28   | Opponent HP ×0.7 (−30%) — applied before the first round | Opponent debuff |

Code **27** is the most powerful DF debuff: the opponent's defense is reduced by 80%. Code **28** reduces the opponent's HP by 30% at the start of the battle, before any attacks are exchanged.

#### Item Curses

These codes affect item cards (weapons, armors, HP restorers) and introduce a chance of the item backfiring.

| Code | Effect |
|------|--------|
| 30   | HP restore item: 50% chance to drain HP instead of restoring it |
| 31   | ST weapon: 50% chance the ST bonus becomes a penalty (negative ST) |
| 32   | DF armor: 50% chance the DF bonus becomes a penalty (negative DF) |

The curse is resolved randomly at the moment the item is played — the player has no way to know in advance whether the item will help or harm.

#### Battle Modifiers *(uncertain)*

The following effects are documented in the original Japanese source material but their exact numerical impact was never officially published. The descriptions below are translations of the original labels.

| Code | Effect |
|------|--------|
| 37   | Own first-strike rate up — increases the probability of attacking before the opponent each round |
| 38   | Own hit rate up — increases the probability of attacks landing |
| 39   | Opponent hit rate up — increases the opponent's chance to land attacks (a self-handicap) |
| 40   | Own hit rate down — decreases own accuracy |
| 41   | Opponent hit rate down — decreases the opponent's accuracy |
| 43   | Opponent recovery rate down — reduces how much HP/PP opponents restore from items |
| 44   | Own recovery rate up — increases how much HP/PP is restored from items |

#### Story Mode Rewards

These effects only apply in Story Mode (C1/C2). When the player defeats a card carrying one of these codes, the hero's stats are permanently boosted by the listed amount for the rest of that story run.

Code **50** marks the hero card itself — the card the player scans as their main character at the start of Story Mode.

| Code | Effect on defeat     |
|------|----------------------|
| 50   | Hero card            |
| 65   | Hero gains +1,000 HP |
| 66   | Hero gains +3,000 HP |
| 70   | Hero gains +200 ST   |
| 71   | Hero gains +400 ST   |
| 72   | Hero gains +600 ST   |
| 73   | Hero gains +800 ST   |
| 75   | Hero gains +200 DF   |
| 76   | Hero gains +400 DF   |
| 77   | Hero gains +600 DF   |
| 78   | Hero gains +800 DF   |

## Optimal Barcodes

The following barcodes produce the most powerful possible cards of each type. All are valid EAN-13 with correct checksums.

### Fighters

In pre-reading mode, all stats can be maximized simultaneously. In post-reading mode, HP and ST reach higher values but digits are shared between stats, resulting in trade-offs. Stats are shown as C0 / C1.

#### Pre-reading

|              | Warrior         | Wizard          |
|--------------|-----------------|-----------------|
| Barcode      | `1999994092799` | `1999994792722` |
| HP           | 19,900 / 1,900  | 19,900 / 1,900  |
| ST           | 9,900  / 1,000  | 9,900  / 1,000  |
| DF           | 9,900  / 1,200  | 9,900  / 1,200  |
| Speed        | 9               | 9               |
| PP           | 5               | 5               |
| MP           | 0               | 10              |

#### Post-reading

|              | Warrior         | Wizard          |
|--------------|-----------------|-----------------|
| Barcode      | `2500000022494` | `2500070022493` |
| HP           | 44,200 / 4,400  | 44,200 / 4,400  |
| ST           | 11,700 / 1,200  | 11,700 / 1,200  |
| DF           | 9,900  / 1,200  | 9,900  / 1,200  |
| Speed        | 4               | 4               |
| PP           | 5               | 5               |
| MP           | 0               | 10              |

### Equipment

Pre-reading equipment is capped at raw 19 (1,900) because the pre-reading condition requires ST ≤ 19 and DF ≤ 19. Post-reading bypasses this limit using prefix-based formulas, reaching up to 3,900 for weapons and 2,900 for armors.

#### Pre-reading

|              | DurableWeapon   | OneUseWeapon    |
|--------------|-----------------|-----------------|
| Barcode      | `0001900609270` | `0001900509273` |
| Bonus        | ST +1,900       | ST +1,900       |

|              | DurableArmor    | OneUseArmor     |
|--------------|-----------------|-----------------|
| Barcode      | `0000019809212` | `0000019709215` |
| Bonus        | DF +1,900       | DF +1,900       |

#### Post-reading

|              | DurableWeapon   | OneUseWeapon    |
|--------------|-----------------|-----------------|
| Barcode      | `2000000084336` | `2000000084305` |
| Bonus        | ST +3,900       | ST +3,900       |

|              | DurableArmor    | OneUseArmor     |
|--------------|-----------------|-----------------|
| Barcode      | `2000000021508` | `2000000021027` |
| Bonus        | DF +2,900       | DF +2,900       |

## Some links

- Barcode Battler II presentation : https://strategygamesevolution.com/barcode-battler-ii/
- Barcodes from game cards: https://fr.scribd.com/doc/292704200/All-Cards-for-Barcode-Battler
- Barcode Battler II detailed analysis (JP): https://barcodebattler.net/
- Barcode Battler II2 Double blog post (JP): https://ameblo.jp/itsuei/entry-10203945374.html
- Strategy Games Evolution — BB II overview: https://strategygamesevolution.com/barcode-battler-ii/
