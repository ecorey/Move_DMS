#[test_only]
module dead_mans_switch::dead_mans_switch_tests {




    use sui::tx_context::{TxContext, Self};
    use sui::object::{Self, UID, ID};
    use sui::clock::{Self, Clock};
    use sui::coin::{Self, Coin, mint_for_testing, burn_for_testing};
    use dead_mans_switch::dead_mans_switch::DEAD_MANS_SWITCH;
    use dead_mans_switch::dead_mans_switch::init_for_testing;

    use sui::sui::SUI;
    use std::option;
    use sui::transfer;
    
    use sui::test_scenario;
    use sui::test_utils::{create_one_time_witness, assert_eq};
    use std::debug;









    // ###################################
    // ############TESTS##################
    // ###################################



    fun init_test_helper() : test_scenario::Scenario {

        let admin = @0x1;
        let user1 = @0x2;


        let scenario = test_scenario::begin(admin);
        let scenario_val = &mut scenario;


        let otw = create_one_time_witness<DEAD_MANS_SWITCH>();


        {
            init_for_testing(otw, test_scenario::ctx(scenario_val));
        };

        scenario

    }




    #[test]
    public fun DMS_tests() {


       
        let admin = @0x1;
        let user1 = @0x2;
       

        
        let scenario = init_test_helper();
        let scenario_val = &mut scenario;



        // Test 1
        test_scenario::next_tx(scenario_val, admin);
        {

        }; 




         // Test 2
        test_scenario::next_tx(scenario_val, admin);
        {

        }; 



        test_scenario::end(scenario);


    }











}