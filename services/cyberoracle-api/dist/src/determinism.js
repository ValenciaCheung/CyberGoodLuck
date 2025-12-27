export function daySeed(date) {
    const y = BigInt(date.getFullYear());
    const m = BigInt(date.getMonth() + 1);
    const d = BigInt(date.getDate());
    return y * 10000n + m * 100n + d;
}
export function stringSeed(value) {
    let hash = 1469598103934665603n;
    const prime = 1099511628211n;
    for (let i = 0; i < value.length; i++) {
        hash ^= BigInt(value.charCodeAt(i));
        hash = (hash * prime) & 0xffffffffffffffffn;
    }
    return hash;
}
export function combineSeeds(a, b) {
    return (a * 6364136223846793005n + b + 0x9e3779b97f4a7c15n) & 0xffffffffffffffffn;
}
export class SplitMix64 {
    state;
    constructor(seed) {
        this.state = seed & 0xffffffffffffffffn;
    }
    nextU64() {
        this.state = (this.state + 0x9e3779b97f4a7c15n) & 0xffffffffffffffffn;
        let z = this.state;
        z = (z ^ (z >> 30n)) * 0xbf58476d1ce4e5b9n & 0xffffffffffffffffn;
        z = (z ^ (z >> 27n)) * 0x94d049bb133111ebn & 0xffffffffffffffffn;
        return (z ^ (z >> 31n)) & 0xffffffffffffffffn;
    }
    nextUnitInterval() {
        const upper53 = this.nextU64() >> 11n;
        return Number(upper53) / Number(1n << 53n);
    }
}
