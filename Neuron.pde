class Neuron
{
    static int ID = 1;

    private int id;

    protected float output;
    protected float internal;
    protected float delta;

    protected ArrayList upstream;
    protected ArrayList downstream;

    protected String label;

    Neuron() {
        id = ID++;
        output = internal = 0.0;
        upstream   = new ArrayList();
        downstream = new ArrayList();
        label = null;

        initPhysics();
    }

    int getID() {
        return id;
    }

    void setLabel(String s) {
        label = s;
    }

    protected boolean isConnectedTo(Neuron n) {
        boolean yn = false;
        for( int i = 0 ; i < downstream.size() ; i++ ) {
            Connection c = (Connection)downstream.get(i);
            if( c.getFrom() == this && c.getTo() == n ) {
                yn = true;
            }
        }
        return yn;
    }

    protected void registerDownstreamConnection(Connection c) {
        downstream.add(c);
    }

    protected void registerUpstreamConnection(Connection c) {
        upstream.add(c);
    }

    void connectTo(Neuron n, float initialWeight) {
        if( !isConnectedTo(n) ) {
            Connection c = new Connection(this, n, new Weight(initialWeight));
            this.registerDownstreamConnection(c);
            n.registerUpstreamConnection(c);
        }
    }

    int getDownstreamCount() {
        return downstream.size();
    }

    Connection getDownstreamConnectionAt(int i) {
        return (Connection)downstream.get(i);
    }

    int getUpstreamCount() {
        return upstream.size();
    }

    Connection getUpstreamConnectionAt(int i) {
        return (Connection)upstream.get(i);
    }

    float getOutput() {
        return output;
    }

    float getDelta() {
        return delta;
    }

    void updateConnection() {
        for( int i = 0 ; i < upstream.size() ; i++ ) {
            Connection c = (Connection)upstream.get(i);
            c.getWeight().update();
        }
    }

    abstract int getType();
    abstract void calculateInternal();
    abstract void calculateOutput();
    abstract void calculateDelta();
    abstract void calculateConnectionUpdate();

    //---------------------------------------------------------------------

    protected float mass = 3.0;
    protected float damp = 0.8;
    protected float R = 20.0;

    PVector pos;
    protected PVector velocity;
    protected PVector force;

    protected boolean isMouseOver;
    protected boolean isPositionFixed;

    void initPhysics() {
        pos      = new PVector(0,0);
        velocity = new PVector(0,0);
        force    = new PVector(0,0);
        isMouseOver = false;
        isPositionFixed = false;
    }

    void setPosition(float x, float y) {
        pos.set(constrain(x, 0 + R, width  - R),
                constrain(y, 0 + R, height - R),
                0);
    }

    void applyForce(PVector f) {
        force.add(f);
    }

    void updateVelocity() {
        if( !isPositionFixed ) {
            for( int i = 0 ; i < upstream.size() ; i++ ) {
                Connection c = (Connection)upstream.get(i);
                force.add(c.getForceFor(this));
            }
            velocity.add(PVector.div(force, mass));
            velocity.mult(damp);
        }
        force.set(0,0,0);
    }

    void move() {
        if( !isPositionFixed ) {
            pos.add(PVector.mult(velocity, 0.5));
            pos.x = constrain(pos.x, 0 + 2 * R, width  - 100  );
            pos.y = constrain(pos.y, 0 + 2 * R, height - 2 * R);
        }
    }

    void draw() {
        for( int i = 0 ; i < downstream.size() ; i++ ) {
            Connection c = (Connection)downstream.get(i);
            c.draw();
        }

        color c1  = color(0,0,255); // blue
        color c2  = color(255,0,0); // red
        color col = lerpColor(c1, c2, min(1.0,max(0.0,getOutput())));

        if( isMouseOver ) {
            stroke(color(255, 255, 255));
        } else {
            stroke(col);
        }

        if( getType() == NeuronType.InputNeuron ) {
            noFill();
            ellipse(pos.x, pos.y, R * 2, R * 2);
            noStroke();
            fill(col);
            ellipse(pos.x, pos.y, R * 1.5, R * 1.5);
        } else if( getType() == NeuronType.HiddenNeuron ) {
            fill(col);
            ellipse(pos.x, pos.y, R * 2, R * 2);
        } else {
            fill(col);
            rect(pos.x - R, pos.y - R, R * 2, R * 2);
        }

        if( label != null ) {
            textSize(18);
            textAlign(LEFT);
            fill(255,255,255);
            text(label, pos.x - R, pos.y + R + 18);
        }

//        fill(255,255,255);
//        text(output, pos.x + R, pos.y + R);
    }

    void mouseOver(boolean yn) {
        isMouseOver = yn;
    }

    void fixed(boolean yn) {
        isPositionFixed = yn;
    }

    float getRadius() {
        return R;
    }

    abstract void mousePressed();
}
