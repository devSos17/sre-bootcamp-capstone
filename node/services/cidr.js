//cidrtomask
export const cidrToMaskFunction = (cidirPrefixStr) => {
    let subnetMask = '';
    let cidrPrefix = parseInt(cidirPrefixStr);

    // Check input
    if (cidrPrefix < 0 || cidrPrefix > 32) {
        return null;
    }

    for (let i = 0; i < 4; i++) {
        let octet = Math.min(cidrPrefix, 8); // Get number of bits for iteration
        cidrPrefix -= octet; // shift bits for next interation

        subnetMask += (256 - Math.pow(2, 8 - octet)).toString(); // Convert to Dec
        if (i < 3) {
            subnetMask += '.';
        }
    }
    return subnetMask;
};
//masktocidr
export const maskToCidrFunction = (mask) => {
    let octets = mask.split('.');
    let cidrPrefix = 0;
    for (let octet of octets) {
        // Check input
        if (octet < 0 || octet > 255) {
            return null;
        }
        // Convert to binary string, split digits and do the sum of them
        cidrPrefix += Number(octet) // Force type to number
            .toString(2) // Bitstring (6) -> '110'
            .split('') // Bit array e.g ['1','1','1'...]
            .reduce((sum, bit) => sum + Number(bit), 0); // Sum bits
    }
    return cidrPrefix;
};
//ipv4validation
export const ipv4ValidationFunction = (value) => {
    //console.log(value);
    return true;
};
