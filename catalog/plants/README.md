# Plants

Each file describes one plant template.

Plants can be planted in the vegetable garden in front of a house or castle.

When a plant has grown, the player chooses what to collect:

* supplies;
* seeds that can be planted again in the vegetable garden.

Therefore, each plant specifies:

* `supplyTemplateId` — which supply the plant yields;
* `supplyAmount` — how many supply units can be collected;
* `seedAmount` — how many seeds can be collected.

Plants can also be obtained as loot. General reward selection rules are described in the [loot documentation](../LOOT.md).

General catalog guidelines are in [`catalog/README.md`](../README.md).

## Example

```json
{
  "templateId": "pumpkin-plant",
  "name": "Pumpkin",
  "description": "A large orange pumpkin.",
  "sourceImageUrl": "https://example.org/pumpkin-plant.png",
  "supplyTemplateId": "pumpkin",
  "supplyAmount": 2,
  "seedAmount": 3
}
```

The published catalog uses `imageKey` instead of `sourceImageUrl`. For details, see the general image guidelines in [`catalog/README.md`](../README.md).

## Supply

`supplyTemplateId` must reference an existing supply in [`../supplies/`](../supplies/).

For example:

```json
{
  "supplyTemplateId": "pumpkin"
}
```

means that when supply collection is chosen, the plant yields the supply with this `templateId`:

```text
pumpkin
```

## Supply quantity

`supplyAmount` determines the number of supply units the player receives when harvesting.

```json
{
  "supplyAmount": 2
}
```

means the plant yields two supply units.

`supplyAmount` must be a positive integer.

## Seed quantity

`seedAmount` determines the number of seeds the player receives if they choose to collect seeds rather than supplies.

```json
{
  "seedAmount": 3
}
```

means three seeds are received.

`seedAmount` must be a positive integer.

## Acquisition sources

A plant can be obtained through various standard methods, including as loot.

If there are no restrictions, there is no need to specify `allowedAcquisitionSources`.

If acquisition methods need to be restricted, use the `allowedAcquisitionSources` allowlist.

For details, see the ["Acquisition sources" section](../README.md#acquisition-sources).

Rules for using plants as rewards are described in the [loot documentation](../LOOT.md).

## Validation

Before opening a pull request, check:

* the plant's `templateId` is unique among plants;
* `supplyTemplateId` references an existing supply;
* `supplyAmount` is a positive integer;
* `seedAmount` is a positive integer;
* `allowedAcquisitionSources` values, if specified, are valid acquisition sources;
* the image is provided through `sourceImageUrl` or `imageKey`, rather than added to the repository as a binary file.
