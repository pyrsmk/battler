# Battler

Display barcode informations as seen by the Barcode Battler II handheld game system.

## Usage

```
battler <ean_digits>
```

The tool accepts any valid EAN-8 or EAN-13 barcode (digits only, checksum validated) and displays the full card stats for both VS Mode and Story Mode.

## TODO

- find the algo in story mode for items (https://fr.scribd.com/doc/292704200/All-Cards-for-Barcode-Battler)

## Barcode Battler II Technical Reference

Barcode Battler II (1992, Epoch) is a handheld game that reads standard EAN barcodes from everyday product packaging and converts them into battle cards. Every barcode produces a unique card with its own stats, type, and special ability — making any barcode scanner a card generator.

### Barcode Formats

The device accepts two standard barcode formats:

| Format | Digits | Notes |
|--------|--------|-------|
| EAN-13 | 13     | Most product barcodes; full stat range |
| EAN-8  | 8      | Compact product barcodes; always uses post-reading |

The last digit is the EAN check digit, calculated from the preceding digits. It also carries meaning in post-reading mode (see below).

---

### Reading Modes

A barcode is decoded using one of two methods. The device selects the method automatically based on specific digit positions.

#### Pre-reading (Direct Mapping)

Stats are read directly from the barcode digits with no transformation. This method applies when:

- The first digit is `0` or `1`, and the race digit (position 7) encodes a fighter race (`0`–`4`)
- The first digit is `0` or `1`, the race digit encodes a non-fighter, and the raw stat values are low (HP ≤ 50, ST ≤ 19, DF ≤ 19)
- The first digit is `2`–`9`, digit at position 2 is `9`, and digit at position 9 is `5`

Digit layout in pre-reading:

```
Position:  0  1  2  3  4  5  6  7  8  9  10 11 12
           [  HP   ] [ST] [DF] [R][J][Sp][Spec ] [CK]

HP  = digits 0–2
ST  = digits 3–4
DF  = digits 5–6
Race    = digit 7
Job     = digit 8
Speed   = digit 9
Special = digits 10–11
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

---

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

---

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

---

### Jobs

Jobs apply to fighters and determine their class. Soldiers and Wizards have different capabilities in battle.

| Job       | Value | Class   | Notes |
|-----------|-------|---------|-------|
| Soldier 0 | 0     | Soldier | — |
| Soldier 1 | 1     | Soldier | — |
| Soldier 2 | 2     | Soldier | — |
| Soldier 3 | 3     | Soldier | — |
| Soldier 4 | 4     | Soldier | — |
| Soldier 5 | 5     | Soldier | — |
| ST Soldier | 6    | Soldier | Special soldier variant; no MP |
| Wizard 7  | 7     | Wizard  | Magic user; starts with 10 MP |
| Wizard 8  | 8     | Wizard  | Magic user; starts with 10 MP |
| Wizard 9  | 9     | Wizard  | Magic user; starts with 10 MP |

Soldiers cannot use magic (MP = 0). Wizards have access to MP-based abilities.

---

### Game Modes

#### C0 Mode (VS, 2-player)

Full stats are used as-is. This is the standard competitive mode where two players face off with their scanned cards.

#### Story Mode (C1)

In single-player story mode, all fighter stats are scaled down using the following formula:

```
HP  = (HP  ÷ 10)
ST  = (ST  ÷ 10) + 1
DF  = (DF  ÷ 10) + 3
```

These values are then multiplied by 100 for the in-game display. For example, a VS Mode card with HP 42,000 / ST 9,500 / DF 7,800 becomes HP 4,200 / ST 1,000 / DF 1,000 in Story Mode.

---

### Special Effects

Each card carries one special effect encoded in the barcode. In pre-reading mode it comes from digits 10–11; in post-reading mode it is derived from digits 8 and 10. A value of `0` means no special effect.

The original Barcode Battler manual deliberately left most of these effects undocumented, encouraging players to discover them through trial and error. The descriptions below come from the original Japanese source material and community reverse-engineering. Effects marked *uncertain* have no confirmed mechanical specification beyond their Japanese label.

---

#### Conditional 3× Attack (「三倍剣」— "Triple Sword")

**Codes 1–8, 10 (job-targeting) and 11–15 (race-targeting)**

The Japanese term 三倍剣 (*sanbai ken*, "triple sword") refers to a conditional attack multiplier. When this card's ST attack lands against an opponent whose **Job** (codes 1–8, 10) or **Race** (codes 11–15) matches the encoded target, the attack deals **3× the card's ST value** instead of the normal amount.

This is the most common special effect in the game. It is highly situational — it does nothing against mismatched opponents — but dominant when the condition is met.

| Code | Trigger condition |
|------|-------------------|
| 1    | Opponent is Job 1 (Soldier 1) |
| 2    | Opponent is Job 2 (Soldier 2) |
| 3    | Opponent is Job 3 (Soldier 3) |
| 4    | Opponent is Job 4 (Soldier 4) |
| 5    | Opponent is Job 5 (Soldier 5) |
| 6    | Opponent is Job 6 (ST Soldier) |
| 7    | Opponent is Job 7 (Wizard 7) |
| 8    | Opponent is Job 8 (Wizard 8) |
| 10   | Opponent is Job 0 (Soldier 0) |
| 11   | Opponent is Race 1 (Animal) |
| 12   | Opponent is Race 2 (Aquatic) |
| 13   | Opponent is Race 3 (Bard) |
| 14   | Opponent is Race 4 (Human) |
| 15   | Opponent is Race 0 (Mechanical) |

---

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

---

#### Item Curses

These codes affect item cards (weapons, armors, HP restorers) and introduce a chance of the item backfiring.

| Code | Effect |
|------|--------|
| 30   | HP restore item: 50% chance to drain HP instead of restoring it |
| 31   | ST weapon: 50% chance the ST bonus becomes a penalty (negative ST) |
| 32   | DF armor: 50% chance the DF bonus becomes a penalty (negative DF) |

The curse is resolved randomly at the moment the item is played — the player has no way to know in advance whether the item will help or harm.

---

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

---

#### Story Mode Rewards

These effects only apply in Story Mode (C1/C2). When the player defeats a card carrying one of these codes, the hero's stats are permanently boosted by the listed amount for the rest of that story run.

Code **50** marks the hero card itself — the card the player scans as their main character at the start of Story Mode.

| Code | Effect on defeat |
|------|-----------------|
| 50   | Hero card — the player's Story Mode protagonist |
| 65   | Hero gains +1,000 HP |
| 66   | Hero gains +3,000 HP |
| 70   | Hero gains +200 ST |
| 71   | Hero gains +400 ST |
| 72   | Hero gains +600 ST |
| 73   | Hero gains +800 ST |
| 75   | Hero gains +200 DF |
| 76   | Hero gains +400 DF |
| 77   | Hero gains +600 DF |
| 78   | Hero gains +800 DF |
