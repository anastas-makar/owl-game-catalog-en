# Supplies

A supply is a root catalog entity. 

Supplies cannot be obtained directly from a pouch, the shop, or after completing an expedition or quest. 

Supplies can be obtained by harvesting in a garden or vegetable garden. Supplies can also be prepared from other supplies using recipes.

Thus, plants, garden items, and recipes may reference supplies.

General guidelines are in [`catalog/README.md`](../README.md).

## Skeleton

```json
{
  "templateId": "pumpkin",
  "name": "Pumpkin",
  "description": "It can be eaten raw, but it is better cooked.",
  "sourceImageUrl": "https://example.org/pumpkin.png",
  "effectType": "HEAL",
  "effectAmount": 50
}
```

### Effect types (`effectType`)

Supplies can be taken on an expedition. During an expedition, they may restore the animal's health or deal damage to an enemy. The expedition outcome depends directly on this.

Effect types:

- `HEAL` — restores the animal's health;
- `DAMAGE` — deals damage to an enemy;
- `NO_EFFECT` — has no effect.

### Effect strength (`effectAmount`)

`effectAmount` determines the effect's strength:

- for `HEAL` — the number of health points restored;
- for `DAMAGE` — the amount of damage dealt to an enemy;
- for `NO_EFFECT` — `0`.

## References

Supplies may be referenced by:

- plants through `supplyTemplateId`;
- garden items through `supplyTemplateId`;
- recipes through `resultSupplyTemplateId`;
- recipe ingredients through `supplyTemplateId`.

Therefore, a published supply `templateId` must not be changed without updating all references.

## Validation

- `templateId` is unique among supplies;
- the name is clear to the player;
- fields match the import DTO;
- the published `templateId` has not changed;
- the image is provided as a link or key.
