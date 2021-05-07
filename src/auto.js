class Auto {
    constructor(marke) {
        this.marke = marke;
        this.ort = "zuhause";
        this.fahren = this.fahren.bind(this);
    }

    fahren(ziel) {
        console.log(`***** Fahre auto ${this.marke} von ${this.ort} nach ${ziel}...`);
        this.ort = ziel;
        return this;
    }

    gps() {
        return this.ort;
    }
}

module.exports = Auto;
