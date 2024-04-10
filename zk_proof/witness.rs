use ark_bn254::Bn254;
use ark_circom::CircomBuilder;
use ark_circom::CircomConfig;
use ark_groth16::Groth16;
use ark_snark::SNARK;


fn main() {

    let cfg = CircomConfig::<Bn254>::new("main.wasm", "main.r1cs").unwrap();


    let mut builder = CircomBuilder::new(cfg);
    
    //  proof shows that an input 7 which, when hashed with the Poseidon hash function, gives a certain output 
    builder.push_input("in", 7);

    let circom = builder.setup();

    let mut rng = rand::thread_rng();
    let params = Groth16::<Bn254>::generate_random_parameters_with_reduction(circom, &mut rng).unwrap();

    let circom = builder.build().unwrap();

    let inputs = circom.get_public_inputs().unwrap();


    let proof = Groth16::<Bn254>::prove(&params, circom, &mut rng).unwrap();



    let pvk = Groth16::<Bn254>::process_vk(&params.vk).unwrap();
    let verified = Groth16::<Bn254>::verify_with_processed_vk(&pvk, &inputs, &proof).unwrap();



    assert!(verified);



}