import React, { Dispatch, SetStateAction } from "react";
import { Button, Modal } from 'flowbite-react';
import { HiOutlineExclamationCircle } from 'react-icons/hi';

type Props = {
    open: boolean;
    setOpen: Dispatch<SetStateAction<boolean>>;
    message: string;
    callback?: () => void;

}

export const ConfirmDialog: React.FC<Props> = ({open, setOpen, message, callback}) => {
    const onConfirm = async () => {
        setOpen(false);
        if (callback) {
            callback()
        }
    }

    return (
        <>
            <Modal show={open} size="md" onClose={() => setOpen(false)} className="dark" popup>
                <Modal.Header />
                <Modal.Body>
                    <div className="text-center">
                        <HiOutlineExclamationCircle className="mx-auto mb-4 h-14 w-14 text-gray-200" />
                        <h3 className="mb-5 text-lg font-normal text-gray-400">
                            {message}
                        </h3>
                        <div className="flex justify-center gap-4">
                            <Button color="failure" onClick={onConfirm}>
                                Confirm
                            </Button>
                            <Button color="gray" onClick={() => setOpen(false)}>
                                Cancel
                            </Button>
                        </div>
                    </div>
                </Modal.Body>
            </Modal>
        </>
    );
}

export default ConfirmDialog