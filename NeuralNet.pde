class NeuralNet
{
    private ArrayList neurons;
    private ArrayList inputNeurons;
    private ArrayList hiddenNeurons;
    private ArrayList outputNeurons;

    NeuralNet(int ni, int nh, int no) {
        neurons = new ArrayList();

        // create neurons
        inputNeurons = new ArrayList();
        for( int i = 0 ; i < ni ; i++ ) {
            InputNeuron n = new InputNeuron();
            inputNeurons.add(n);
            neurons.add(n);
        }

        hiddenNeurons = new ArrayList();
        for( int i = 0 ; i < nh ; i++ ) {
            HiddenNeuron n = new HiddenNeuron();
            hiddenNeurons.add(n);
            neurons.add(n);
        }

        outputNeurons = new ArrayList();
        for( int i = 0 ; i < no ; i++ ) {
            OutputNeuron n = new OutputNeuron();
            outputNeurons.add(n);
            neurons.add(n);
        }

        // then connect them
        for( int i = 0 ; i < inputNeurons.size() ; i++ ) {
            InputNeuron from = (InputNeuron)inputNeurons.get(i);
            for( int j = 0 ; j < hiddenNeurons.size() ; j++ ) {
                HiddenNeuron to = (HiddenNeuron)hiddenNeurons.get(j);
                from.connectTo(to,0.0);
            }
        }

        for( int i = 0 ; i < hiddenNeurons.size() ; i++ ) {
            HiddenNeuron from = (HiddenNeuron)hiddenNeurons.get(i);
            for( int j = 0 ; j < outputNeurons.size() ; j++ ) {
                OutputNeuron to = (OutputNeuron)outputNeurons.get(j);
                from.connectTo(to,0.0);
            }
        }

        initPhysics();
    }

    void calculateOutput() {
        for( int i = 0 ; i < inputNeurons.size() ; i++ ) {
            InputNeuron n = (InputNeuron)inputNeurons.get(i);
            n.calculateInternal();
            n.calculateOutput();
        }

        for( int i = 0 ; i < hiddenNeurons.size() ; i++ ) {
            HiddenNeuron n = (HiddenNeuron)hiddenNeurons.get(i);
            n.calculateInternal();
            n.calculateOutput();
        }

        for( int i = 0 ; i < outputNeurons.size() ; i++ ) {
            OutputNeuron n = (OutputNeuron)outputNeurons.get(i);
            n.calculateInternal();
            n.calculateOutput();
        }
    }

    void calculateDelta() {
        for( int i = 0 ; i < outputNeurons.size() ; i++ ) {
            OutputNeuron n = (OutputNeuron)outputNeurons.get(i);
            n.calculateDelta();
        }

        for( int i = 0 ; i < hiddenNeurons.size() ; i++ ) {
            HiddenNeuron n = (HiddenNeuron)hiddenNeurons.get(i);
            n.calculateDelta();
        }
    }

    void calculateConnectionUpdate() {
        for( int i = 0 ; i < outputNeurons.size() ; i++ ) {
            OutputNeuron n = (OutputNeuron)outputNeurons.get(i);
            n.calculateConnectionUpdate();
        }

        for( int i = 0 ; i < hiddenNeurons.size() ; i++ ) {
            HiddenNeuron n = (HiddenNeuron)hiddenNeurons.get(i);
            n.calculateConnectionUpdate();
        }
    }

    void updateConnection() {
        for( int i = 0 ; i < outputNeurons.size() ; i++ ) {
            OutputNeuron n = (OutputNeuron)outputNeurons.get(i);
            n.updateConnection();
        }

        for( int i = 0 ; i < hiddenNeurons.size() ; i++ ) {
            HiddenNeuron n = (HiddenNeuron)hiddenNeurons.get(i);
            n.updateConnection();
        }
    }

    void randomizeConnection() {
        for( int i = 0 ; i < hiddenNeurons.size() ; i++ ) {
            HiddenNeuron n = (HiddenNeuron)hiddenNeurons.get(i);
            for( int j = 0 ; j < n.getUpstreamCount() ; j++ ) {
                Connection c = n.getUpstreamConnectionAt(j);
                c.getWeight().resetToValue(1.0 * random() - 0.5);
            }
        }

        for( int i = 0 ; i < outputNeurons.size() ; i++ ) {
            OutputNeuron n = (OutputNeuron)outputNeurons.get(i);
            for( int j = 0 ; j < n.getUpstreamCount() ; j++ ) {
                Connection c = n.getUpstreamConnectionAt(j);
                c.getWeight().resetToValue(1.0 * random() - 0.5);
            }
        }
    }

    int getNeuronCount() {
        return neurons.size();
    }

    Neuron getNeuronAt(int i) {
        return (Neuron)neurons.get(i);
    }

    int getInputNeuronCount() {
        return inputNeurons.size();
    }

    InputNeuron getInputNeuronAt(int i) {
        return (InputNeuron)inputNeurons.get(i);
    }

    int getOutputNeuronCount() {
        return outputNeurons.size();
    }

    InputNeuron getOutputNeuronAt(int i) {
        return (OutputNeuron)outputNeurons.get(i);
    }

    float[] getTrainingSet() {
        float[] set = new float[inputNeurons.size() + outputNeurons.size()];

        int cnt = 0;
        for( int i = 0 ; i < inputNeurons.size() ; i++ ) {
            InputNeuron n = (InputNeuron)inputNeurons.get(i);
            set[cnt++] = n.getInput();
        }

        for( int i = 0 ; i < outputNeurons.size() ; i++ ) {
            OutputNeuron n = (OutputNeuron)outputNeurons.get(i);
            set[cnt++] = n.getTeach();
        }

        return set;
    }

    void setTrainingSet(float[] set) {
        int cnt = 0;
        for( int i = 0 ; i < inputNeurons.size() ; i++ ) {
            InputNeuron n = (InputNeuron)inputNeurons.get(i);
            n.setInput(set[cnt++]);
        }

        for( int i = 0 ; i < outputNeurons.size() ; i++ ) {
            OutputNeuron n = (OutputNeuron)outputNeurons.get(i);
            n.setTeach(set[cnt++]);
        }
    }

    //----------------------------------------------------------------------------

    private CoulombForce cforce;

    void initPhysics() {
        // init position
        for( int i = 0 ; i < inputNeurons.size() ; i++ ) {
            Neuron n = (Neuron)inputNeurons.get(i);
            float x = random(0, width / 3);
            float y = random(0, height);
            n.setPosition(x, y);
        }

        for( int i = 0 ; i < hiddenNeurons.size() ; i++ ) {
            Neuron n = (Neuron)hiddenNeurons.get(i);
            float x = random(width / 3, 2 * width / 3);
            float y = random(0, height);
            n.setPosition(x, y);
        }

        for( int i = 0 ; i < outputNeurons.size() ; i++ ) {
            Neuron n = (Neuron)outputNeurons.get(i);
            float x = random(2 * width / 3, width);
            float y = random(0, height);
            n.setPosition(x, y);
        }

        // set natural length of connections
        float naturalLength = sqrt((width * height) / (neurons.size()));
        for( int i = 0 ; i < neurons.size() ; i++ ) {
            Neuron n = (Neuron)neurons.get(i);
            for( int j = 0 ; j < n.getUpstreamCount() ; j++ ) {
                Connection c = (Connection)n.getUpstreamConnectionAt(j);
                c.setNaturalLength(naturalLength);
            }
        }
        // init Coulomb Force
        cforce = new CoulombForce(neurons);
    }

    void move() {
        cforce.applyForce();
        for( int i = 0 ; i < neurons.size() ; i++ ) {
            Neuron n = (Neuron)neurons.get(i);
            n.updateVelocity();
        }
        for( int i = 0 ; i < neurons.size() ; i++ ) {
            Neuron n = (Neuron)neurons.get(i);
            n.move();
        }
    }

    void draw() {
        for( int i = 0 ; i < neurons.size() ; i++ ) {
            Neuron n = (Neuron)neurons.get(i);
            n.draw();
        }
    }
}
