import tensorflow as tf
import numpy as np
from tensorflow.keras import layers, models
import os

# Create the model
def create_model():
    model = models.Sequential([
        layers.Conv2D(32, (3, 3), activation='relu', input_shape=(224, 224, 3)),
        layers.MaxPooling2D((2, 2)),
        layers.Conv2D(64, (3, 3), activation='relu'),
        layers.MaxPooling2D((2, 2)),
        layers.Conv2D(64, (3, 3), activation='relu'),
        layers.Flatten(),
        layers.Dense(64, activation='relu'),
        layers.Dense(1, activation='sigmoid')
    ])
    return model

# Create and compile the model
model = create_model()
model.compile(
    optimizer='adam',
    loss='binary_crossentropy',
    metrics=['accuracy']
)
# Create dummy data for testing
dummy_data = np.random.random((100, 224, 224, 3))
dummy_labels = np.random.randint(2, size=(100, 1))

# Train the model with dummy data
model.fit(dummy_data, dummy_labels, epochs=1)

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_types = [tf.float16]
tflite_model = converter.convert()

# Create assets directory if it doesn't exist
os.makedirs('../assets/ml', exist_ok=True)

# Save the model
with open('../assets/ml/plant_detector.tflite', 'wb') as f:
    f.write(tflite_model)

print("Model saved successfully!")
