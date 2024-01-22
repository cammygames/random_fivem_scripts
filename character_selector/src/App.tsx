import React, {Dispatch, SetStateAction, useRef, useState} from "react";
import "./App.css";
import {debugData} from "./utils/debugData.ts";
import {fetchNui} from "./utils/fetchNui.ts";
import {useNuiEvent} from "./hooks/useNuiEvent.ts";
import ConfirmDialog from "./components/ConfirmDialog.tsx";
import NewCharacter from "./components/NewCharacter.tsx";
import {sideScroll} from "./utils/misc.ts";


// This will set the NUI to visible if we are
// developing in browser

debugData([
    {
        action: "setVisible",
        data: true,
    },

    {
        action: "setChars",
        // @ts-expect-error not real error
        data: [{
            citizenid: "CITIZENID",
            name: "MAIN MAN",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }, {
            citizenid: "CITIZENID",
            name: "NAME HERE",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }, {
            citizenid: "CITIZENID",
            name: "NAME HERE",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }, {
            citizenid: "CITIZENID",
            name: "NAME HERE",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }, {
            citizenid: "CITIZENID",
            name: "NAME HERE",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }, {
            citizenid: "CITIZENID",
            name: "NAME HERE",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }, {
            citizenid: "CITIZENID",
            name: "NAME HERE",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }, {
            citizenid: "CITIZENID",
            name: "NAME HERE",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }, {
            citizenid: "CITIZENID",
            name: "NAME HERE",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }, {
            citizenid: "CITIZENID",
            name: "NAME HERE",
            job: "job",
            image: "https://previews.123rf.com/images/fordzolo/fordzolo1506/fordzolo150600296/41026708-example-white-stamp-text-on-red-backgroud.jpg"
        }],
    },

    {
        action: "enableNew",
        data: true,
    },

]);

interface Character {
    citizenid: number;
    name: string;
    job: string;
    image: string;
}

type ProfileProps = {
    char: Character;
    setDeleteConfirmOpen: Dispatch<SetStateAction<boolean>>;
    setSelectedChar: Dispatch<SetStateAction<Character | undefined>>;
}

const Profile: React.FC<ProfileProps> = ({char, setDeleteConfirmOpen, setSelectedChar}) => {

    const onSelect = async () => {
        await fetchNui("selectChar", char.citizenid)
    }

    const onDelete = async () => {
        setSelectedChar(char)
        setDeleteConfirmOpen(true)
    }

    const doPreview = async () => {
        await fetchNui("previewChar", char.citizenid)
    }

    return (
        <div className="relative overflow-hidden rounded-lg group min-w-fit" onClick={doPreview} onMouseEnter={doPreview}>
            <img
                className="object-cover w-full h-[250px]"
                src={char.image} alt=""/>
            <div
                className="absolute inset-0 grid items-end justify-center p-1 bg-gradient-to-b from-transparent to-black/60">
                <div>
                    <div className="text-center">
                        <p className="text-xl font-bold text-white">
                            {char.name}
                        </p>
                        <p className="text-base font-medium text-gray-300">
                            {char.job}
                        </p>
                    </div>
                    <div>
                        <a className="inline-flex items-center justify-center py-2.5 px-5 my-5 text-sm rounded-l-lg font-medium focus:outline-none border focus:z-10 focus:ring-4 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-green-500 dark:hover:bg-gray-700 dark:hover:border-green-500" onClick={onSelect}>
                            <svg aria-hidden="true" className="mr-1 w-5 h-5" fill="none" stroke="currentColor"
                                 viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                            </svg>
                            Select
                        </a>
                        <a className="inline-flex items-center justify-center py-2.5 px-5 my-5 text-sm rounded-r-lg font-medium focus:outline-none border focus:z-10 focus:ring-4 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-red-500 dark:hover:bg-gray-700 dark:hover:border-red-500" onClick={onDelete}>
                            <svg className="mr-1 w-5 h-5" aria-hidden="true"
                                 xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 18 20">
                                <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2"
                                      d="M1 5h16M7 8v8m4-8v8M7 1h4a1 1 0 0 1 1 1v3H6V2a1 1 0 0 1 1-1ZM3 5h12v13a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V5Z"/>
                            </svg>
                            Delete
                        </a>
                    </div>
                </div>
            </div>
        </div>

    );
}

const App: React.FC = () => {
    const [char, setChar] = useState<Character>();
    const [chars, setChars] = useState<Character[]>();
    const [enableCreate, setEnableCreate] = useState<boolean>(true);
    const [isConfirmOpen, setConfirmOpen] = useState<boolean>(false);
    const [isCreateOpen, setCreateOpen] = useState<boolean>(false);

    const scrollElement = useRef(null)

    useNuiEvent<Character[]>("setChars", setChars);
    useNuiEvent<boolean>("enableNew", setEnableCreate);

    const onClickExit = async () => {
        await fetchNui("exitChar")
    }

    const onDeleteConfirm = async () => {
        if (!char) return;

        await fetchNui("deleteChar", char.citizenid)
        setChar(undefined);
    }

    if (!chars) {
        return (
            <>LOADING.....</>
        )
    }

    return (
        <div className="static w-full dark">
            <footer className="absolute w-full bottom-0 left-0 selector-bg">
                <div className="pl-72 pr-72 pb-1">
                    <div className="pt-20">
                        <div className="flex flex-row">
                            {chars.length > 7 ? (<button className="mr-5" onClick={() => {
                                if (!scrollElement.current) return;
                                sideScroll(scrollElement.current, 30, 100, -20);
                            }}>
                                <svg className="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true"
                                     xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 8 14">
                                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                          stroke-width="2" d="M7 1 1.3 6.326a.91.91 0 0 0 0 1.348L7 13"/>
                                </svg>
                            </button>): null}
                            <div
                                className={`flex w-full flex-row rounded-lg p-4 space-x-4 overflow-x-scroll no-scrollbar ${chars.length < 7 ? "justify-center" : ""}`} ref={scrollElement}>
                                {chars.map((char) => <Profile char={char} setSelectedChar={setChar}
                                                              setDeleteConfirmOpen={setConfirmOpen}/>)}
                            </div>
                            {chars.length > 7 ? (<button className="ml-5" onClick={() => {
                                if (!scrollElement.current) return;
                                sideScroll(scrollElement.current, 30, 100, 20);
                            }}>
                                <svg className="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true"
                                     xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 8 14">
                                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                          stroke-width="2" d="m1 13 5.7-5.326a.909.909 0 0 0 0-1.348L1 1"/>
                                </svg>
                            </button>) : null}
                        </div>
                        <div className="pl-72 pr-72 grid grid-cols-2">
                            {enableCreate ? (
                                <>
                                    <a className="inline-flex items-center justify-center py-2.5 px-5 my-5 text-sm rounded-l-lg w-full font-medium focus:outline-none border focus:z-10 focus:ring-4 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-green-500 dark:hover:bg-gray-700 dark:hover:border-green-500"
                                       onClick={() => setCreateOpen(true)}>
                                        <svg className="mr-1 w-5 h-5" aria-hidden="true"
                                             xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 18 18">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                                  stroke-width="2" d="M9 1v16M1 9h16"/>
                                        </svg>
                                        New
                                    </a>
                                </>
                            ) : null}
                            <div className={enableCreate ? "" : "col-span-2"}>
                                <a className={`inline-flex items-center justify-center py-2.5 px-5 my-5 text-sm ${enableCreate ? "rounded-r-lg" : "rounded-lg"} w-full font-medium focus:outline-none border focus:z-10 focus:ring-4 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-red-500 dark:hover:bg-gray-700 dark:hover:border-red-500`}
                                   onClick={onClickExit}>
                                    <svg className="mr-1 w-5 h-5" aria-hidden="true"
                                         xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                              stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                    </svg>
                                    Exit
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <ConfirmDialog open={isConfirmOpen} setOpen={setConfirmOpen}
                               message={`Are you sure you want to delete ${char?.name || "this character"}?`}
                               callback={onDeleteConfirm}/>
                <NewCharacter open={isCreateOpen} setOpen={setCreateOpen} cid={chars.length+1}/>
            </footer>
        </div>
    )
};

export default App;