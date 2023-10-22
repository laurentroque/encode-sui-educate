module nft_tutorial::nft_example {

    use sui::url::{Self, Url};
    use sui::tx_context::{sender, TxContext};
    use std::string::{utf8, String};
    use sui::transfer;
    use sui::object::{Self, UID};
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

    fun init(otw: NFT_EXAMPLE, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"description"),
            utf8(b"image_url"),
        ];

        let values = vector[
            utf8(b"{name}"),
            utf8(b"{description}"),
            utf8(b"{image_url}"),
        ];

        let publisher = package::claim(otw, ctx);

        let display = display::new_with_fields<NFT>(
            &publisher, keys, values, ctx
        );

        display::update_version(&mut display);

        transfer::public_transfer(publisher, sender(ctx));
        transfer::public_transfer(display, sender(ctx));
    }

}
