class Weight
{
    private float value;
    private float up;

    Weight(float v) {
        value = v;
        up = 0;
    }

    void resetToValue(float v) {
        value = v;
        up = 0;
    }

    void addToUpdate(float v) {
        up += v;
    }

    void update() {
        value += up
        up = 0;
    }

    float getValue() {
        return value;
    }
}
