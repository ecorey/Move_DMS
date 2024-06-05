module dead_mans_switch::dead_mans_switch {

    // Dead Mans Switch


    // There is a period of time established for routine check ins
    // at the beginning of a period it is checked that:
    // the event_check_in minus the period_count is equal to 0.
    // if it is not equal to 0 then the information is unencrypted and released
    // or released woth the private key of the owner
    

    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::clock::{Self, Clock};
    use std::option::{Self, Option};
    use sui::event;
    use sui::package::{Self, Publisher};
    use sui::transfer;
    use std::hash;
    use std::vector;
    use std::string::String;

    use sui::groth16;



    #[test_only]
    friend dead_mans_switch::dead_mans_switch_tests;



    

    // ##########ERRORS##########
    const ECountIncorrect: u64 = 1;




    // ##########CONST##########
    






    // ##########EVENTS##########
    // event for DMS creation
    struct DMS_Created has copy, drop, store {
        owner: address,
        timestamp: u64,
        check_period: u64,
    }


    // event for DMS check in
    struct DMS_Check_In has copy, drop, store {
        owner: address,
        timestamp: u64
    }


    // event for a new DMS check period began after set period
    struct DMS_New_Check_Period_Began has copy, drop, store {
        owner: address,
        timestamp: u64
    }

    // event to get time from a timestamp_ms
    struct TimeEvent has copy, drop, store {
        timestamp_ms: u64
    }




    // ##########STRUCTS##########
    // DeadMansSwitch that has container that holds the ecrypted information
    // releases the information if the owner does not check in via events
    // other users can see the information if the owner does not check in through subscribing to events
    // container should be set to a table or bag
    // owner just needs to check in to keep the information private not add
    // DAta to be stored should be encrypted and a Generic type
    struct DeadMansSwitch has key, store {

        id: UID,
        owner: address,
        timestamp: u64,
        dms_container: Option<String>,
        event_check_period: u64,
        event_check_in_count: u64,
        check_period_count: u64,
        dms_verified: bool,

    }




    // ##########PUBLIC_FUNCTIONS##########
    
    // GET TIME VIA EVENT
    public fun get_time(clock: &Clock)  {
        event::emit(TimeEvent {
            timestamp_ms: clock::timestamp_ms(clock),
        });

    }



    public fun create_dead_mans_switch(clock: &Clock, ctx: &mut TxContext) : DeadMansSwitch {



        event::emit(DMS_Created {
            owner: tx_context::sender(ctx),
            timestamp: clock::timestamp_ms(clock),
            check_period: 180_000
        });



        let dms = DeadMansSwitch {
            id: object::new(ctx),
            timestamp: clock::timestamp_ms(clock),
            owner: tx_context::sender(ctx),
            dms_container: option::none<String>(),
            event_check_period: 180_000, // for example every 3 minutes 
            event_check_in_count: 0,
            check_period_count: 0,
            dms_verified: true,
            };


        dms

    }




    // use subscribe to events to get the information
    public fun check_in(dms: &mut DeadMansSwitch, clock: &Clock, ctx: &mut TxContext) {


        event::emit(DMS_Check_In {
            owner: tx_context::sender(ctx),
            timestamp: clock::timestamp_ms(clock),
        });

        
        assert!(dms.event_check_in_count == dms.check_period_count, ECountIncorrect);


        dms.event_check_in_count = dms.event_check_in_count + 1;
        



    }


    // hashed output
    struct HashedOutput has key, store {
        id: UID,
        value: vector<u8>,
    }




    public fun hash_message(message: vector<u8>, recipient: address, ctx: &mut TxContext) {

        let hashed_message = HashedOutput {
            id: object::new(ctx),
            value: hash::sha2_256(message),
        };

        transfer::public_transfer(hashed_message, recipient);


    }


    struct VerifiedZKProof has copy, drop {
        is_verified: bool,
    }



    // needs a circom circut script to generate the proof
    public fun zk_proof_hash_ownership(vk_bytes: vector<u8>, public_input_bytes: vector<u8>, proof_points_bytes: vector<u8>) {
        let pvk = groth16::prepare_verifying_key(&groth16::bn254(), &vk_bytes);
        let public_inputs = groth16::public_proof_inputs_from_bytes(public_input_bytes);
        let proof_points = groth16::proof_points_from_bytes(proof_points_bytes);

        event::emit(VerifiedZKProof {
            is_verified: groth16::verify_groth16_proof(&groth16::bn254(), &pvk, &public_inputs, &proof_points)
        });


    }




    public fun add_to_container(dms: &mut DeadMansSwitch, message: vector<u8>, ctx: &mut TxContext) {



    }







    struct DEAD_MANS_SWITCH has drop {}
    



    fun init(otw: DEAD_MANS_SWITCH, ctx: &mut TxContext) {

        let publisher = package::claim(otw, ctx);






        transfer::public_transfer(publisher, tx_context::sender(ctx));




    }

















    #[test_only]
    public fun init_for_testing(otw: DEAD_MANS_SWITCH, ctx: &mut TxContext) {
        init(otw, ctx );
    }



}