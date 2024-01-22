import {Button, Datepicker, Label, Modal, Select, TextInput} from 'flowbite-react';
import {Dispatch, SetStateAction, useEffect, useState} from 'react';
import {fetchNui} from "../utils/fetchNui.ts";

type Props = {
    open: boolean;
    setOpen: Dispatch<SetStateAction<boolean>>;
    cid: number;
}

export const NewCharacter: React.FC<Props> = ({open, setOpen, cid}) => {
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [nationality, setNationality] = useState('');
    const [sex, setSex] = useState<number>(0);
    const [dob, setDob] = useState('');

    useEffect(() => {
        if (open) return;

        setFirstName('');
        setLastName('');
        setDob('');
        setSex(0);
        setNationality('');
    }, [open, setOpen]);

    const onSubmit = async () => {
        setOpen(false);

        await fetchNui("newChar", {
            firstname: firstName,
            lastname: lastName,
            nationality,
            sex,
            dob,
            cid
        })
    };

    return (
        <>
            <Modal show={open} size="xl" onClose={() => {setOpen(false)}} className="dark" popup>
                <Modal.Header />
                <Modal.Body>
                    <div className="space-y-6">
                        <h3 className="text-xl font-medium text-white text-center">New Character</h3>
                        <div>
                            <div className="mb-2 block">
                                <Label htmlFor="firstName" value="First Name"/>
                            </div>
                            <TextInput
                                id="firstName"
                                value={firstName}
                                onChange={(event) => setFirstName(event.target.value)}
                                required
                            />
                        </div>
                        <div>
                            <div className="mb-2 block">
                                <Label htmlFor="lastName" value="Last Name"/>
                            </div>
                            <TextInput
                                id="lastName"
                                value={lastName}
                                onChange={(event) => setLastName(event.target.value)}
                                required
                            />
                        </div>
                        <div>
                            <div className="mb-2 block">
                                <Label htmlFor="nationality" value="Nationality"/>
                            </div>
                            <TextInput
                                id="nationality"
                                value={nationality}
                                onChange={(event) => setNationality(event.target.value)}
                                required
                            />
                        </div>
                        <div>
                            <div className="mb-2 block">
                                <Label htmlFor="sex" value="Sex"/>
                            </div>
                            <Select id="sex" defaultValue="0" onChange={(event) => setSex(Number(event.target.value))}>
                                <option value="0">Male</option>
                                <option value="1">Female</option>
                            </Select>
                        </div>
                        <div>
                            <div className="mb-2 block">
                                <Label htmlFor="dob" value="Date of Birth"/>
                            </div>
                            <div className="flex items-center justify-center">
                                <Datepicker
                                    id="dob"
                                    minDate={new Date(1970, 0, 1)}
                                    maxDate={new Date(new Date().getFullYear() - 18, 11, 31)}
                                    onSelectedDateChanged={(date) => setDob(date.toISOString().substring(0, 10))}
                                    inline
                                    required
                                    showClearButton={false}
                                    showTodayButton={false}
                                />
                            </div>
                        </div>

                        <div className="w-full">
                            <Button className="w-full" onClick={onSubmit}>Submit</Button>
                        </div>
                    </div>
                </Modal.Body>
            </Modal>
        </>
    );
}


export default NewCharacter;