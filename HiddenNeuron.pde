class HiddenNeuron extends Neuron {

    protected float WEIGHT_UPDATE_RATE = 0.1;
    protected float T = 1.0;

    protected float doutput;

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

    int getType() {
        return NeuronType.HiddenNeuron;
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
        delta = 0.0;
        for( int i = 0 ; i < downstream.size() ; i++ ) {
            Connection c = (Connection)downstream.get(i);
            delta += c.getTo().getDelta() * c.getWeight().getValue();
        }
    }

    void calculateConnectionUpdate() {
        for( int i = 0 ; i < upstream.size() ; i++ ) {
            Connection c = (Connection)upstream.get(i);
            Weight w = c.getWeight();
            w.addToUpdate(-WEIGHT_UPDATE_RATE * delta * doutput * c.getFrom().getOutput());
        }
    }

    //--------------------------------------------------------------------------------

    void mousePressed() {
    }
}
