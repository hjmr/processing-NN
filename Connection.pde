class Connection
{
    private Neuron from, to;
    private Weight weight;

    Connection(Neuron f, Neuron t, Weight w) {
        from   = f;
        to     = t;
        weight = w;
    }

    Neuron getFrom() {
        return from;
    }

    Neuron getTo() {
        return to;
    }

    Weight getWeight() {
        return weight;
    }



    private float naturalLength = 10.0;
    private float lc = 2.0;
    private float k = 0.005;

    void setNaturalLength(float l) {
        naturalLength = lc * l;
    }

    PVector calcSpringForce() {
        PVector f = PVector.sub(to.pos, from.pos);
        float mag = k * (f.mag() - naturalLength);
        f.normalize();
        f.mult(mag);
        return f;
    }

    PVector getForceFor(Neuron n) {
        PVector force = calcSpringForce();
        if( n == to ) {
            force.mult(-1);
        }
        return force;
    }

    void draw() {
        color c1  = color( 40, 40, 40);
        color c2  = color(200,200,200);
        color col = lerpColor(c1, c2, (max(-1.0, min(1.0,weight.getValue())) + 1.0) / 2.0);

        noFill();
        stroke(col);
        strokeWeight(3);
        line(from.pos.x, from.pos.y, to.pos.x, to.pos.y);

//        fill(180,180,180);
//        text(weight.getValue(), (from.pos.x + to.pos.x) / 2.0, (from.pos.y + to.pos.y) / 2.0);
    }
}
