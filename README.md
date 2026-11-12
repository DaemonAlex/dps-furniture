# dps-furniture

Puts your streamed furniture packs into the qs-housing furniture shop.

## What it is for

A server can stream hundreds of furniture props from bought packs. Players cannot use any of
them in their homes until each one is listed in the housing script's furniture shop. Typing
them in by hand is slow, and the list is lost when the housing script updates. This script adds
them at every boot, with a name, a price, a picture and style choices.

## What it does

- Reads the list of furniture models in `data/models.lua`. Models are grouped into sets.
- Looks up a photo for each model in the `dps_studio_thumbs` table.
- Builds one shop item per set. The first model with a photo is the main piece. The others
  with photos become its style choices (Style A, Style B and so on).
- Picks a qs-housing shop category from the model name, for example couch, bed, lamp or
  painting.
- Gives each item a plain label, such as "Dubai Living Sofa 1A".
- Sets a flat price: 500 for big furniture, 300 for paintings, 150 for small decor.
- Skips any set with no photo, so the shop never shows a blank picture.
- Skips any pack that is not started.
- Prints one line in the server console with how many items were added, skipped and failed.

## On its own, and with other scripts

**On its own it does nothing.** It is a helper for one paid script. Without qs-housing there is
no furniture shop to add to.

**With a paid housing script (qs-housing).** Players open the furniture shop in their home and
find the new pieces in the normal categories, with pictures and style choices. Items go in
through qs-housing's own `AddFurniture` export. Nothing inside qs-housing is edited, so a
qs-housing update does not remove them.

**With [dps-studio](https://github.com/DaemonAlex/dps-studio).** The Studio photo booth takes
the pictures and fills the `dps_studio_thumbs` table. This script only reads that table. Take
photos of a new pack in the booth, restart dps-furniture, and the pack appears in the shop.

**With paid furniture prop packs.** The pieces come from streamed pack resources. A pack must
be started for its pieces to be listed. The packs it knows today are in the table below.

## Requirements

- `qs-housing` (paid)
- `oxmysql`
- The `dps_studio_thumbs` table, filled by the dps-studio photo booth
- The furniture pack resources you want to sell

## Install

1. Put the folder in your resources and add `ensure dps-furniture` after `oxmysql`,
   `qs-housing` and the furniture packs.
2. Take photos of the furniture in the dps-studio photo booth.
3. Restart `dps-furniture`. Read the console line to see what was added.

## Configuration

There is no config file. The rules are tables at the top of `server.lua`.

| Setting | Meaning |
|---|---|
| `PACKS` | One line per pack: the shop label, the default category, and the name prefix to drop. |
| `CATEGORY` | Which qs-housing category a word in the model name maps to. |
| `WORD` | The plain word shown in the shop for a word in the model name. |
| `BIG` and `priceFor` | Which categories count as big furniture, and the three flat prices. |
| `STYLE` | The label for each style letter, `a` to `j`. |
| `data/models.lua` | Every model, grouped into sets. One set is one shop item. |

Packs it knows:

| Pack resource | Shop label |
|---|---|
| `AEG_PROPS_livingroom-dubai` | Dubai Living |
| `AEG_props_PetzAmsterda` | Petz Amsterdam |
| `AEG_props_PetzDublin` | Petz Dublin |
| `AEG_props_PetzLondon` | Petz London |
| `BohoBathroom` | Boho Bathroom |
| `BedroomSet` | Bedroom Set |
| `Coffee` | Coffee Corner |
| `LunaticStudio_VanGogh` | Van Gogh |
| `lunaticstudio23_bathroom_1` | Spa Bathroom |
| `lunaticstudio23_kitchen_1` | Kitchen One |
| `lunaticstudio23_kitchen_2` | Kitchen Two |
| `lunaticstudio23_kitchen_3` | Kitchen Three |
| `lunaticstudio23_office_1` | Home Office |
| `ate_furniture_hall1` | Hallway |

## Recent changes

- **12 November 2026.** README added.
- **10 November 2026.** Script written. Model list built from the furniture packs on the server.

## Author

Made by [DaemonAlex](https://github.com/DaemonAlex) for DelPerroSands.

## Other DPS scripts

All of these are made for DelPerroSands and run together on one Qbox server. Each one works on
its own. The ones marked "pairs with" do more when both are running.

| Script | What it does |
|---|---|
| [dps-inventory](https://github.com/DaemonAlex/dps-inventory) | The inventory: ox_inventory with equipment slots, backpacks, armour plates and a self status panel, in the DelPerroSands colours. |
| [dps-medical](https://github.com/DaemonAlex/dps-medical) | Patient records, illness and diagnostic tests. A companion to wasabi_ambulance. Pairs with dps-inventory: symptoms and diagnoses show on the status panel. |
| [dps-insurance](https://github.com/DaemonAlex/dps-insurance) | Ties m-Insurance into the MDT, impound, hospital and medical chart. Pairs with dps-medical. |
| [dps-studio](https://github.com/DaemonAlex/dps-studio) | Build rooms, doors and portals in game from one panel (`/studio`), with owners and managers so staff do not have to support them. |
| [dps-shops](https://github.com/DaemonAlex/dps-shops) | Shop clerks who greet and react to a robbery, then player-owned shops. |
| [dps-fleet](https://github.com/DaemonAlex/dps-fleet) | Vehicle browser and workshop on one panel: extras, liveries and mods for emergency vehicles. |
| [dps-parking](https://github.com/DaemonAlex/dps-parking) | Parking with valet, impound, violations and reserved spots. |
| [dps-vehiclepersistence](https://github.com/DaemonAlex/dps-vehiclepersistence) | Vehicles stay where they were parked. Pairs with dps-parking. |
| [dps-towjob](https://github.com/DaemonAlex/dps-towjob) | Queue-based tow job with jg-mechanic integration. |
| [dps-services](https://github.com/DaemonAlex/dps-services) | Request a tow and follow it live on the lb-phone and lb-tablet. Pairs with dps-towjob. |
| [dps-autoshops](https://github.com/DaemonAlex/dps-autoshops) | Self-service repair shops when no mechanic is on duty. |
| [dps-cityworker](https://github.com/DaemonAlex/dps-cityworker) | City infrastructure job and career. |
| [dps-ainpcs](https://github.com/DaemonAlex/dps-ainpcs) | NPCs you can talk to, with trust, quests and intel. |
| [dps-badpeds](https://github.com/DaemonAlex/dps-badpeds) | Police interaction with NPCs: stops, arrests, intel and jail records. |
| [dps-gangwars](https://github.com/DaemonAlex/dps-gangwars) | Ambient gang NPCs, territory population and war reinforcements. |
| [dps-rotations](https://github.com/DaemonAlex/dps-rotations) | Moves dealers, harvests and other spots on a fixed schedule. |
| [dps-trains](https://github.com/DaemonAlex/dps-trains) | The train system. Pairs with dps-trains-stock, dps-traintools and dps-transitapp. |
| [dps-transitapp](https://github.com/DaemonAlex/dps-transitapp) | Live train arrival boards on the lb-phone. |
| [dps-faceplant](https://github.com/DaemonAlex/dps-faceplant) | City help, reports and staff tools on the lb-phone and lb-tablet. |
| [dps-chat](https://github.com/DaemonAlex/dps-chat) | A command box for voice-only servers. No chat feed. |
| [dps-filmmode](https://github.com/DaemonAlex/dps-filmmode) | One key hides every HUD layer and gives a smooth free camera for recording. |
