module dead_mans_switch::dead_mans_switch {




    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::clock::{Self, Clock};
    use std::option::{Self, Option};

    use std::string::String;



    



    // event for DMS
    struct DMS_Event has copy, drop, store {
        owner: address,
        timestamp: u64
    }




    // DeadMansSwitch that has container that holds the ecrypted information
    // releases the information if the owner does not check in via events
    // other users can see the information if the owner does not check in through subscribing to events
    struct DeadMansSwitch has key, store {


        id: UID,
        owner: address,
        timestamp: u64,
        dms_container: Option<String>,


    }





    public fun create_dead_mans_switch(clock: &Clock, ctx: &mut TxContext) : DeadMansSwitch {

        let dms = DeadMansSwitch {
            id: object::new(ctx),
            timestamp: clock::timestamp_ms(clock),
            owner: tx_context::sender(ctx),
            dms_container: option::none<String>(),
        };



        dms

    }






}