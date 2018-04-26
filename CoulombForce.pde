class CoulombForce {

    protected ArrayList neurons;
    protected float C = 50000;

    CoulombForce(ArrayList n) {
        neurons = n;
    }

    void applyForce() {
        float naturalLength = sqrt((width * height) / neurons.size());
        for( int i = 0 ; i < neurons.size() - 1 ; i++ ) {
            Neuron from = (Neuron)neurons.get(i);
            for( int j = i + 1 ; j < neurons.size() ; j++ ) {
                Neuron to = (Neuron)neurons.get(j);

                float dist = from.pos.dist(to.pos);
                if( 0 < dist ) {
                    PVector force = getForce(from, to);
                    if( from.getType() == to.getType() && naturalLength < dist ) {
                        force.mult(-1);
                    }

                    to.applyForce(force);
                    force.mult(-1);
                    from.applyForce(force);
                }
            }
        }
    }

    protected PVector getForce(Node from, Node to) {
        PVector f = PVector.sub(to.pos, from.pos);
        float mag = C / (f.mag() * f.mag());
        f.normalize();
        f.mult(mag);
        return f;
    }
}
