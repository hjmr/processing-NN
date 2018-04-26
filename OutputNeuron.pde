class OutputNeuron extends Neuron {

    protected float WEIGHT_UPDATE_RATE = 0.1;
    protected float T = 1.0;

    protected float teach;
    protected float doutput;

    OutputNeuron() {
        teach = 0.0;
    }

    private float sigmoid(float x) {
        float y = 1.0 / (1.0 + exp(-x / T));
        return y;
    }

    private float outputFunction(float x) {
        float y = sigmoid(x);
        return y;
    }

    private float doutputFunction(float x) {
        float y = sigmoid(x) * (1.0 - sigmoid(x)) / T;
        return y;
    }

    void setTeach(float v) {
        teach = v;
    }

    float getTeach() {
        return teach;
    }

    int getType() {
        return NeuronType.OutputNeuron;
    }

    void calculateInternal() {
        internal = 0.0;
        for( int i = 0 ; i < upstream.size() ; i++ ) {
            Connection c = (Connection)upstream.get(i);
            internal += c.getWeight().getValue() * c.getFrom().getOutput();
        }
    }

    void calculateOutput() {
        output  =  outputFunction(internal);
        doutput = doutputFunction(internal);
    }

    void calculateDelta() {
        delta = (teach - output) * -1.0 * doutput;
    }

    void calculateConnectionUpdate() {
        for( int i = 0 ; i < upstream.size() ; i++ ) {
            Connection c = (Connection)upstream.get(i);
            Weight w = c.getWeight();
            w.addToUpdate(-WEIGHT_UPDATE_RATE * delta * c.getFrom().getOutput());
        }
    }

    //--------------------------------------------------------------------------------

    void draw() {
        super.draw();

        color c1  = color( 80,0,0);
        color c2  = color(255,0,0);
        color col = lerpColor(c1, c2, min(1.0,max(0.0,teach)));
        
        noStroke();
        fill(col);
        ellipse(pos.x + R, pos.y - R, R * 0.5, R * 0.5);
    }

    void mousePressed() {
        teach = 1.0 - teach;
    }
}
