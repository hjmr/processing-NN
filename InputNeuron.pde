class InputNeuron extends Neuron {

    protected float input;

    InputNeuron() {
        input = 0.0;
    }

    void setInput(float v) {
        input = v;
    }

    float getInput() {
        return input;
    }

    int getType() {
        return NeuronType.InputNeuron;
    }

    void calculateInternal() {
        internal = input;
    }

    void calculateOutput() {
        output = internal;
    }

    void calculateDelta() {
        delta = 0.0;
        for( int i = 0 ; i < downstream.size() ; i++ ) {
            Connection c = (Connection)downstream.get(i);
            delta += c.getTo().getDelta() * c.getWeight();
        }
    }

    void calculateConnectionUpdate() {
    }

    //--------------------------------------------------------------------------------

    void draw() {
        super.draw();

        color c1  = color( 80,0,0);
        color c2  = color(255,0,0);
        color col = lerpColor(c1, c2, min(1.0,max(0.0,input)));
        
        noStroke();
        fill(col);
        ellipse(pos.x + R, pos.y - R, R * 0.5, R * 0.5);
    }

    void mousePressed() {
        input = 1.0 - input;
    }
}
