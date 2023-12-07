
# crytography imports
from cryptography.hazmat.backends               import default_backend
from cryptography.hazmat.primitives             import serialization
from cryptography.hazmat.primitives.asymmetric  import rsa


def generate_rsa_key_pair():
    print("Generating RSA key pair...")
    try:
        # Generate private key
        private_key = rsa.generate_private_key(
                        public_exponent=65537,
                        key_size=2048,
                        backend=default_backend()
        )

    except (ValueError, KeyError) as e:
        print(f"Error in rsa.generate_private_key(): {type(e).__name__}: {str(e)}")
        return None, None

    try:
        # Generate private PEM
        private_pem = private_key.private_bytes(
                        encoding=serialization.Encoding.PEM,
                        format=serialization.PrivateFormat.PKCS8,
                        encryption_algorithm=serialization.NoEncryption()
        )

    except (ValueError, KeyError) as e:
        print(f"Error in private_key.private_bytes: {type(e).__name__}: {str(e)}")
        return None, None

    try:
        # Get public key
        public_key = private_key.public_key()

    except (ValueError, KeyError) as e:
        print(f"Error in private_key.public_key(): {type(e).__name__}: {str(e)}")
        return None, None

    try:
        # Generate public PEM
        public_pem = public_key.public_bytes(
                        encoding=serialization.Encoding.PEM,
                        format=serialization.PublicFormat.SubjectPublicKeyInfo
        )

        private_pem = private_pem.decode('utf-8')
        public_pem = public_pem.decode('utf-8')

        return private_pem, public_pem

    except (ValueError, KeyError, AttributeError, UnicodeDecodeError) as e:
        print(f"Error in public_key.public_bytes: {type(e).__name__}: {str(e)}")
        return None, None
