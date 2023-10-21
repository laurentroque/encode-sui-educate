module nft_tutorial::nft_example {

    use sui::url::{Self, Url};
    use sui::tx_context::{sender, TxContext};
    use std::string::{utf8, String};
    use sui::transfer;
    use sui::object::{Self, UID};

    // The creator bundle: these two packages often go together.
    use sui::package;
    use sui::display;

    struct NFT has key, store {
        id: UID,
        name: String,
        description: String,
        image_url: Url,
    }

    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = sender(ctx);
        let nft = NFT {
            id: object::new(ctx),
            name: utf8(name),
            description: utf8(description),
            image_url: url::new_unsafe_from_bytes(url)
        };

        transfer::transfer(nft, sender);
    }

    struct NFT_EXAMPLE has drop {}

    /// In the module initializer we claim the `Publisher` object
    /// to then create a `Display`. The `Display` is initialized with
    /// a set of fields (but can be modified later) and published via
    /// the `update_version` call.
    ///
    /// Keys and values are set in the initializer but could also be
    /// set after publishing if a `Publisher` object was created.
    fun init(otw: NFT_EXAMPLE, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"description"),
            //utf8(b"link"),
            utf8(b"image_url"),
            //utf8(b"project_url"),
            //utf8(b"creator"),
        ];

        let values = vector[
            // For `name` we can use the `NFT.name` property
            utf8(b"{name}"),
            // Description is static for all `NFT` objects.
            utf8(b"{description}"),
            // For `link` we can build a URL using an `id` property
            //utf8(b"https://sui-heroes.io/hero/{id}"),
            // For `image_url` we use an IPFS template + `img_url` property.
            utf8(b"{image_url}"),
            //utf8(b"https://upload.wikimedia.org/wikipedia/en/4/43/Digimon_Digital_Monsters_Season_1_DVD_Cover.png"),
            //utf8(b"https://raw.githubusercontent.com/laurentroque/encode-sui-educate/main/nft_tutorial/test/test.png"),
            // Project URL is usually static
            //utf8(b"https://sui-heroes.io"),
            // Creator field can be any
            //utf8(b"Unknown Sui Fan")
        ];

        // Claim the `Publisher` for the package!
        let publisher = package::claim(otw, ctx);

        // Get a new `Display` object for the `NFT` type.
        let display = display::new_with_fields<NFT>(
            &publisher, keys, values, ctx
        );

        // Commit first version of `Display` to apply changes.
        display::update_version(&mut display);

        transfer::public_transfer(publisher, sender(ctx));
        transfer::public_transfer(display, sender(ctx));
    }

}
